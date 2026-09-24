import 'package:flutter/material.dart';

class ContactProfileScreen extends StatefulWidget {
  final String contactName;

  const ContactProfileScreen({Key? key, required this.contactName}) : super(key: key);

  @override
  State<ContactProfileScreen> createState() => _ContactProfileScreenState();
}

class _ContactProfileScreenState extends State<ContactProfileScreen> {
  bool isBlocked = false;
  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[850],
            elevation: 0,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Text(
                          widget.contactName[0],
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.contactName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'En ligne',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations de contact',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.blue),
                      title: const Text(
                        '+33 6 12 34 56 78',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.mail, color: Colors.blue),
                      title: const Text(
                        'contact@example.com',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Conversation',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.volume_off, color: isMuted ? Colors.blue : Colors.grey),
                      title: Text(
                        isMuted ? 'Notifications activées' : 'Notifications désactivées',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => setState(() => isMuted = !isMuted),
                    ),
                    ListTile(
                      leading: const Icon(Icons.block, color: Colors.red),
                      title: Text(
                        isBlocked ? 'Bloquer' : 'Débloquer',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => setState(() => isBlocked = !isBlocked),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.red[900],
                      ),
                      child: const Text('Supprimer la conversation'),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}