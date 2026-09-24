import 'package:flutter/material.dart';
import 'inbox_screen.dart';

class EmailValidationScreen extends StatefulWidget {
  final String email;

  const EmailValidationScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<EmailValidationScreen> createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
  final codeController = TextEditingController();
  bool isLoading = false;

  Future<void> validateEmail() async {
    if (codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez le code de validation')),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InboxScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: const Text('Valider votre e-mail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mail_outline, size: 48, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Vérifiez votre e-mail',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Un lien de validation a été envoyé à ${widget.email}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: codeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Entrez le code',
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
              onPressed: isLoading ? null : validateEmail,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.blue,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Valider l\'e-mail'),
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
    codeController.dispose();
    super.dispose();
  }
}