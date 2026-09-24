import 'package:flutter/material.dart';
import 'sms_validation_screen.dart';

class SMSConfirmationScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String email;

  const SMSConfirmationScreen({
    Key? key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
  }) : super(key: key);

  @override
  State<SMSConfirmationScreen> createState() => _SMSConfirmationScreenState();
}

class _SMSConfirmationScreenState extends State<SMSConfirmationScreen> {
  bool isLoading = false;

  Future<void> sendSMS() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SMSValidationScreen(
          phoneNumber: widget.phoneNumber,
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: widget.email,
        ),
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
        title: const Text('Confirmation SMS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sms_outlined, size: 64, color: Colors.blue),
            const SizedBox(height: 32),
            const Text(
              'Vérification par SMS',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Un code de vérification chiffré sera envoyé à:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.phoneNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chiffrement de bout en bout',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'Votre code n\'est jamais stocké sur nos serveurs',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading ? null : sendSMS,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.blue,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Envoyer le code SMS'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Retour',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}