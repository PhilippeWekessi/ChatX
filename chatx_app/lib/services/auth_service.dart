import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();
  static const _tokenKey = 'auth_token';
  static const _storage = FlutterSecureStorage();
  static const _apiBaseUrl = String.fromEnvironment(
    'CHATX_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _post(
      Uri.parse('$_apiBaseUrl/auth/login'),
      {'email': email, 'password': password},
    );

    await _saveTokenFromResponse(response);
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _post(
      Uri.parse('$_apiBaseUrl/auth/register'),
      {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    await _saveTokenFromResponse(response);
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } on PlatformException catch (error) {
      throw AuthException(
        error.message ?? 'Impossible de lire la session enregistrée.',
      );
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } on PlatformException catch (error) {
      throw AuthException(
        error.message ?? 'Impossible de supprimer la session enregistrée.',
      );
    }
  }

  Future<http.Response> _post(
    Uri uri,
    Map<String, String> body,
  ) async {
    try {
      return await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } on http.ClientException {
      throw const AuthException('Impossible de contacter le serveur.');
    }
  }

  Future<void> _saveTokenFromResponse(http.Response response) async {
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const AuthException('Réponse invalide du serveur.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const AuthException('Réponse invalide du serveur.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(_errorMessage(decoded, response.statusCode));
    }

    final token = decoded['token'];
    if (token is! String || token.isEmpty) {
      throw const AuthException('Le serveur n’a pas fourni de jeton.');
    }

    try {
      await _storage.write(key: _tokenKey, value: token);
    } on PlatformException catch (error) {
      throw AuthException(
        error.message ?? 'Impossible de protéger la session sur cet appareil.',
      );
    }
  }

  String _errorMessage(Map<String, dynamic> response, int statusCode) {
    if (statusCode == 401) {
      return 'Adresse e-mail ou mot de passe incorrect.';
    }

    final errors = response['errors'];
    if (errors is Map<String, dynamic>) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty && value.first is String) {
          return value.first as String;
        }
      }
    }

    final message = response['message'] ?? response['error'];
    if (message is String && message.isNotEmpty) {
      return message;
    }

    return 'La demande a échoué (HTTP $statusCode).';
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}
