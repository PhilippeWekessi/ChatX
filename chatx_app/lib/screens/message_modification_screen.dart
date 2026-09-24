import 'package:flutter/material.dart';

class MessageModificationScreen extends StatefulWidget {
  final String originalMessage;
  final Function(String) onUpdate;

  const MessageModificationScreen({
    Key? key,
    required this.originalMessage,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<MessageModificationScreen> createState() => _MessageModificationScreenState();
}

class _MessageModificationScreenState extends State<MessageModificationScreen> {
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController(text: widget.originalMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: const Text('Modifier le message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Modifiez votre message',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: messageController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Entrez votre message...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.grey[800],
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onUpdate(messageController.text);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.red[900],
              ),
              child: const Text('Supprimer le message'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}