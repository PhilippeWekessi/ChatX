import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String selectedFilter = 'Tous';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('ChatX'),
        backgroundColor: Colors.grey[850],
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stories Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Statuts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 12),
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
            SizedBox(height: 16),

            // Filters
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Tous', 'Non lus', 'Groupes', 'Canaux'].map((filter) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
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
            SizedBox(height: 16),

            // Conversations List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Appels'),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: 'Stories'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }

  Widget _buildStoryAvatar(String name, Color color, bool isOwn) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: color,
            child: Text(name[0], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          if (isOwn)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: Icon(Icons.add, color: Colors.white, size: 12),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.grey[900])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, int index) {
    final conversations = [
      {'name': 'Project Alpha', 'type': 'Groupe', 'message': 'Thomas: Les maquettes sont prêtes !', 'time': '10:42', 'unread': 2},
      {'name': 'Léa Martin', 'type': '', 'message': 'On s\'appelle après le déj ?', 'time': '10:15', 'unread': 1},
      {'name': 'Karim Alami', 'type': '', 'message': 'Note vocale (0:24)', 'time': '09:30', 'unread': 0},
      {'name': 'Sarah Connor', 'type': '', 'message': 'Merci pour le document !', 'time': 'Hier', 'unread': 0},
      {'name': 'Design Squad', 'type': 'Groupe', 'message': 'Chloé: Regardez ce lien d\'inspiration F...', 'time': 'Hier', 'unread': 0},
    ];

    final conv = conversations[index];
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blue,
        child: Text(conv['name'][0], style: TextStyle(color: Colors.white)),
      ),
      title: Row(
        children: [
          Text(conv['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          if (conv['type'].toString().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
                child: Text(conv['type'], style: TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            ),
        ],
      ),
      subtitle: Text(conv['message'], style: TextStyle(color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        alignItems: TextAlign.right,
        children: [
          Text(conv['time'], style: TextStyle(fontSize: 12, color: Colors.grey)),
          if (conv['unread'] > 0)
            Container(
              margin: EdgeInsets.only(top: 4),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: Text(conv['unread'].toString(), style: TextStyle(color: Colors.white, fontSize: 11)),
            ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(contactName: conv['name'])),
      ),
    );
  }
}

// Chat Screen
class ChatScreen extends StatefulWidget {
  final String contactName;
  ChatScreen({required this.contactName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();

  final messages = [
    {'sender': 'other', 'text': 'Coucou ! Tu as pu jeter un œil aux nouveaux écrans de l\'app ?', 'time': '10:12', 'emoji': '✨'},
    {'sender': 'me', 'text': 'Yes, c\'est super propre ! J\'adore la palette sombre et les transitions.', 'time': '10:14'},
    {'sender': 'other', 'text': 'Want to grab coffee?', 'time': '10:15', 'isVoice': true, 'duration': '0:24'},
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
            Text(widget.contactName, style: TextStyle(color: Colors.white)),
            Text('En train d\'écrire...', style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                bool isSent = msg['sender'] == 'me';

                return Align(
                  alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSent ? Colors.blue : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (msg['isVoice'] == true)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey[700],
                                child: Icon(Icons.play_arrow, size: 16, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.graphic_eq, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text(msg['duration'], style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          )
                        else
                          Text(msg['text'], style: TextStyle(color: isSent ? Colors.white : Colors.white)),
                        SizedBox(height: 4),
                        Text(msg['time'], style: TextStyle(fontSize: 10, color: isSent ? Colors.white70 : Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              border: Border(top: BorderSide(color: Colors.grey[700])),
            ),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.add), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () {
                      print('Message: ${messageController.text}');
                      messageController.clear();
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