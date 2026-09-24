import 'package:flutter/material.dart';
import 'dart:async';

class VoiceCallScreen extends StatefulWidget {
  final String contactName;

  const VoiceCallScreen({Key? key, required this.contactName}) : super(key: key);

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  late Timer timer;
  int seconds = 0;
  bool isMuted = false;
  bool isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => seconds++);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int totalSeconds) {
    int mins = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Text(
                widget.contactName[0],
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.contactName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              formatTime(seconds),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Appel en cours...',
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () => setState(() => isMuted = !isMuted),
                  backgroundColor: isMuted ? Colors.red : Colors.grey[800],
                  child: Icon(isMuted ? Icons.mic_off : Icons.mic, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: () => setState(() => isSpeakerOn = !isSpeakerOn),
                  backgroundColor: isSpeakerOn ? Colors.blue : Colors.grey[800],
                  child: Icon(Icons.volume_up, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}