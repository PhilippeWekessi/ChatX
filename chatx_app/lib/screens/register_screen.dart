import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sms_confirmation_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';
  int currentStep = 1;
  bool acceptTerms = false;

  Future<void> register() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Tous les champs sont obligatoires');
      return;
    }

    if (passwordController.text != passwordConfirmController.text) {
      setState(() => errorMessage = 'Les mots de passe ne correspondent pas');
      return;
    }

    if (!acceptTerms) {
      setState(() => errorMessage = 'Acceptez les conditions d\'utilisation');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'password': passwordController.text,
          'password_confirmation': passwordConfirmController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SMSConfirmationScreen(
              phoneNumber: '+33 ${phoneController.text}',
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
            ),
          ),
        );
      } else {
        setState(() => errorMessage = 'Erreur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => errorMessage = 'Erreur: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Créer un compte ChatX'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('ÉTAPE $currentStep SUR 2', style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              const Text('Créer un compte ChatX', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('Rejoignez la messagerie privée et sécurisée sans compromis.', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.facebook),
                      label: const Text('Facebook'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.mail),
                      label: const Text('Google'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text('OU AVEC VOS IDENTIFIANTS', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'ex: Alex',
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelText: 'Prénom',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'ex: Dubois',
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelText: 'Nom',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text('Numéro de téléphone', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: 'FR',
                      items: ['FR', 'US', 'UK'].map((String value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (value) {},
                      underline: const SizedBox(),
                      dropdownColor: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '6 12 34 56 78',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixText: '+33 ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Un code SMS chiffré sera envoyé pour valider votre appareil.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 24),

              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'nom@domaine.com',
                  hintStyle: const TextStyle(color: Colors.grey),
                  labelText: 'Adresse e-mail (récupération & sécurité)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••••••',
                  hintStyle: const TextStyle(color: Colors.grey),
                  labelText: 'Créer un mot de passe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  suffixIcon: const Icon(Icons.visibility, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text('8+ caractères', style: TextStyle(fontSize: 12, color: Colors.green)),
                  const SizedBox(width: 16),
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text('1 symbole (@#\$)', style: TextStyle(fontSize: 12, color: Colors.green)),
                  const SizedBox(width: 16),
                  const Icon(Icons.radio_button_unchecked, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text('1 chiffre', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordConfirmController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••••••',
                  hintStyle: const TextStyle(color: Colors.grey),
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  suffixIcon: const Icon(Icons.visibility, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Checkbox(
                    value: acceptTerms,
                    onChanged: (value) => setState(() => acceptTerms = value ?? false),
                  ),
                  const Expanded(
                    child: Text(
                      'J\'accepte les Conditions d\'utilisation et la Politique de confidentialité & Chiffrement.',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.green, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Protocole Zéro Connaissance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text('Aucune collecte de métadonnées personnelles. Vos clés privées restent sur cet appareil.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: isLoading ? null : register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.blue,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Continuer & Vérifier le numéro'),
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ),
                  child: const Text('Vous avez déjà un compte ? Se connecter', style: TextStyle(fontSize: 13, color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }
}