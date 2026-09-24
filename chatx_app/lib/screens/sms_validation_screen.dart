import 'package:flutter/material.dart';
import 'email_validation_screen.dart';

class SMSValidationScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String email;

  const SMSValidationScreen({
    Key? key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
  }) : super(key: key);

  @override
  State<SMSValidationScreen> createState() => _SMSValidationScreenState();
}

class _SMSValidationScreenState extends State<SMSValidationScreen> {
  final otpController = TextEditingController();
  bool isLoading = false;

  Future<void> validateOTP() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez le code OTP')),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EmailValidationScreen(email: widget.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: const Text('Validation SMS OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sms, size: 48, color: Colors.blue),
            const SizedBox(height: 24),
            const Text('Vérifiez votre numéro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Text(
              'Un code SMS a été envoyé au ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: otpController,
              style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 10),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : validateOTP,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.blue,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Vérifier'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Renvoyer le code',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
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