import 'package:flutter/material.dart';
import 'login_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String selectedFilter = 'Tous';
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('ChatX'),
        backgroundColor: Colors.grey[850],
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Statuts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStoryAvatar('Vous', Colors.blue, true),
                        _buildStoryAvatar('Léa M.', Colors.cyan, false),
                        _buildStoryAvatar('Thomas B.', Colors.purple, false),
                        _buildStoryAvatar('Chloé D.', Colors.green, false),
                        _buildStoryAvatar('Karim A.', Colors.orange, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Tous', 'Non lus', 'Groupes', 'Canaux'].map((filter) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: selectedFilter == filter,
                        onSelected: (bool selected) {
                          setState(() => selectedFilter = filter);
                        },
                        backgroundColor: Colors.grey[800],
                        selectedColor: Colors.blue,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildConversationTile(context, index);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[850],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Appels'),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: 'Stories'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Déconnexion'),
        ],
      ),
    );
  }

  Widget _buildStoryAvatar(String name, Color color, bool isOwn) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: color,
            child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          if (isOwn)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 12),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[900]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, int index) {
    final conversations = [
      {
        'name': 'Project Alpha',
        'type': 'Groupe',
        'message': 'Thomas: Les maquettes sont prêtes !',
        'time': '10:42',
        'unread': 2,
      },
      {
        'name': 'Léa Martin',
        'type': '',
        'message': 'On s\'appelle après le déj ?',
        'time': '10:15',
        'unread': 1,
      },
      {
        'name': 'Karim Alami',
        'type': '',
        'message': 'Note vocale (0:24)',
        'time': '09:30',
        'unread': 0,
      },
      {
        'name': 'Sarah Connor',
        'type': '',
        'message': 'Merci pour le document !',
        'time': 'Hier',
        'unread': 0,
      },
      {
        'name': 'Design Squad',
        'type': 'Groupe',
        'message': 'Chloé: Regardez ce lien d\'inspiration F...',
        'time': 'Hier',
        'unread': 0,
      },
    ];

    final conv = conversations[index];
    final name = conv['name'] as String;
    final type = conv['type'] as String;
    final message = conv['message'] as String;
    final time = conv['time'] as String;
    final unread = conv['unread'] as int;

    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blue,
        child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      title: Row(
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          if (type.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(type, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            ),
        ],
      ),
      subtitle: Text(message, style: const TextStyle(color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          if (unread > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(unread.toString(), style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(contactName: name)),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String contactName;
  
  const ChatScreen({Key? key, required this.contactName}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();

  final messages = [
    {'sender': 'other', 'text': 'Coucou ! Tu as pu jeter un œil aux nouveaux écrans de l\'app ?', 'time': '10:12'},
    {'sender': 'me', 'text': 'Yes, c\'est super propre ! J\'adore la palette sombre et les transitions.', 'time': '10:14'},
    {'sender': 'other', 'text': 'Voice message', 'time': '10:15', 'isVoice': true, 'duration': '0:24'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.contactName, style: const TextStyle(color: Colors.white, fontSize: 16)),
            const Text('En train d\'écrire...', style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final sender = msg['sender'] as String;
                final isVoice = msg['isVoice'] as bool? ?? false;
                bool isSent = sender == 'me';

                return Align(
                  alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSent ? Colors.blue : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (isVoice)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey[700],
                                child: const Icon(Icons.play_arrow, size: 16, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.graphic_eq, size: 16, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(msg['duration'] as String, style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          )
                        else
                          Text(msg['text'] as String, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(msg['time'] as String, style: TextStyle(fontSize: 10, color: isSent ? Colors.white70 : Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              border: Border(top: BorderSide(color: Colors.grey[700]!)),
            ),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.add), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}