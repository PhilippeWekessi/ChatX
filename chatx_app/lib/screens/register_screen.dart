import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'inbox_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
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
        final data = jsonDecode(response.body);
        print('Token: ${data['token']}');
        
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SMSValidationScreen()),
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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Créer un compte ChatX'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
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
                  SizedBox(width: 8),
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
              SizedBox(height: 16),
              Text('ÉTAPE $currentStep SUR 2', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),

              Text('Créer un compte ChatX', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Rejoignez la messagerie privée et sécurisée sans compromis.', style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: 32),

              // OAuth buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.facebook),
                      label: Text('Facebook'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        minimumSize: Size.fromHeight(48),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.mail),
                      label: Text('Google'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        minimumSize: Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Text('OU AVEC VOS IDENTIFIANTS', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              // Form fields
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'ex: Alex',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Prénom',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'ex: Dubois',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Nom',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Text('Numéro de téléphone', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: 'FR',
                      items: ['FR', 'US', 'UK'].map((String value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (value) {},
                      underline: SizedBox(),
                      dropdownColor: Colors.grey[800],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '6 12 34 56 78',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixText: '+33 ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text('Un code SMS chiffré sera envoyé pour valider votre appareil.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 24),

              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'nom@domaine.com',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Adresse e-mail (récupération & sécurité)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[700]),
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••••••',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Créer un mot de passe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[700]),
                  ),
                  suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Text('8+ caractères', style: TextStyle(fontSize: 12, color: Colors.green)),
                  SizedBox(width: 16),
                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Text('1 symbole (@#\$)', style: TextStyle(fontSize: 12, color: Colors.green)),
                  SizedBox(width: 16),
                  Icon(Icons.radio_button_unchecked, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('1 chiffre', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 16),

              TextField(
                controller: passwordConfirmController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••••••',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[700]),
                  ),
                  suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                ),
              ),
              SizedBox(height: 24),

              Row(
                children: [
                  Checkbox(
                    value: acceptTerms,
                    onChanged: (value) => setState(() => acceptTerms = value ?? false),
                  ),
                  Expanded(
                    child: Text(
                      'J\'accepte les Conditions d\'utilisation et la Politique de confidentialité & Chiffrement.',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield, color: Colors.green, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Protocole Zéro Connaissance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Aucune collecte de métadonnées personnelles. Vos clés privées restent sur cet appareil.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              if (errorMessage.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(errorMessage, style: TextStyle(color: Colors.red[300])),
                ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: isLoading ? null : register,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Colors.blue,
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Continuer & Vérifier le numéro'),
              ),
              SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                  child: Text('Vous avez déjà un compte ? Se connecter', style: TextStyle(fontSize: 13, color: Colors.blue)),
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

// SMS Validation Screen
class SMSValidationScreen extends StatefulWidget {
  @override
  State<SMSValidationScreen> createState() => _SMSValidationScreenState();
}

class _SMSValidationScreenState extends State<SMSValidationScreen> {
  final otpController = TextEditingController();
  bool isLoading = false;

  Future<void> validateOTP() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entrez le code OTP')),
      );
      return;
    }

    setState(() => isLoading = true);

    // Simuler validation
    await Future.delayed(Duration(seconds: 1));

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InboxScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: Text('Validation SMS OTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sms, size: 48, color: Colors.blue),
            SizedBox(height: 24),
            Text('Vérifiez votre numéro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 12),
            Text('Un code SMS a été envoyé au +33 6 12 34 56 78', style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 32),
            TextField(
              controller: otpController,
              style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 10),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]),
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : validateOTP,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.blue,
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Vérifier'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}