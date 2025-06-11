import 'package:flutter/material.dart';
import 'package:start_up/screens/Profile.dart'; // Make sure this import path is correct

class ChatScreen extends StatefulWidget {
  final String username;
  final String name;

  const ChatScreen({super.key, required this.username, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'initial': 'F',
      'name': 'Fatima Abbas',
      'message': 'Oui',
      'time': 'il y a 27 min',
      'image': 'images/profile.jpg' // Add your image path
    },
    {
      'initial': 'M',
      'name': 'Mohamed Derar',
      'message': 'votre commande est ...',
      'time': 'il y a 4h',
      'image': 'images/profile.jpg' // Add your image path
    }
  ];

  final List<Map<String, dynamic>> _questions = [
    {
      'initial': 'F',
      'name': 'Fatima Abbas',
      'question': 'J\'ai besoin d\'une assistante',
      'time': 'il y a 2h',
      'image': 'images/profile.jpg'
    },
    {
      'initial': 'A',
      'name': 'Amel Drisi',
      'answer': 'On peut discuter les détails au privé',
      'time': 'il y a 1h',
      'image': 'images/profile.jpg'
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: "Q&A"),
            Tab(text: "Messages"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Questions Tab
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final item = _questions[index];
                    return Column(
                      children: [
                        if (item['question'] != null)
                          _buildQuestionItem(
                            initial: item['initial'],
                            name: item['name'],
                            question: item['question'],
                            time: item['time'],
                            image: item['image'],
                          ),
                        if (item['answer'] != null)
                          _buildAnswerItem(
                            initial: item['initial'],
                            name: item['name'],
                            answer: item['answer'],
                            time: item['time'],
                            image: item['image'],
                          ),
                        if (index < _questions.length - 1)
                          const Divider(height: 24),
                      ],
                    );
                  },
                ),
                
                // Messages Tab
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return GestureDetector(
                            onTap: () => _navigateToConversation(context, message),
                            child: Column(
                              children: [
                                _buildMessageItem(
                                  initial: message['initial'],
                                  name: message['name'],
                                  message: message['message'],
                                  time: message['time'],
                                  image: message['image'],
                                ),
                                if (index < _messages.length - 1)
                                  const Divider(height: 24),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    _buildMessageInputField(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Écrire un message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.pink),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.insert(0, {
          'initial': 'M',
          'name': 'Moi',
          'message': _messageController.text,
          'time': 'Maintenant',
          'image': 'images/my_profile.jpg'
        });
        _messageController.clear();
      });
    }
  }

  void _navigateToConversation(BuildContext context, Map<String, dynamic> message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          userName: message['name'],
          userImage: message['image'],
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context, String name, String image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>Profile(userImage: "image/post.png", userName: "me")
         
      ),
    );
  }

  Widget _buildMessageItem({
    required String initial,
    required String name,
    required String message,
    required String time,
    required String image,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _navigateToProfile(context, name, image),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(image),
            child: image.isEmpty
                ? Text(
                    initial,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionItem({
    required String initial,
    required String name,
    required String question,
    required String time,
    required String image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => _navigateToProfile(context, name, image),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage(image),
                child: image.isEmpty
                    ? Text(
                        initial,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            question,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerItem({
    required String initial,
    required String name,
    required String answer,
    required String time,
    required String image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => _navigateToProfile(context, name, image),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage(image),
                child: image.isEmpty
                    ? Text(
                        initial,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            answer,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class ConversationScreen extends StatefulWidget {
  final String userName;
  final String userImage;

  const ConversationScreen({
    super.key,
    required this.userName,
    required this.userImage,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _conversation = [
    {
      'message': 'Bonjour, comment puis-je vous aider?',
      'time': 'il y a 10 min',
      'isMe': false
    },
    {
      'message': 'Je suis intéressé par votre produit',
      'time': 'il y a 5 min',
      'isMe': true
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.userImage),
              radius: 16,
            ),
            const SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _conversation.length,
              itemBuilder: (context, index) {
                final message = _conversation[index];
                return _buildMessageBubble(
                  message: message['message'],
                  time: message['time'],
                  isMe: message['isMe'],
                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required String time,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFF8B3BB) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Écrire un message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.pink),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _conversation.insert(0, {
          'message': _messageController.text,
          'time': 'Maintenant',
          'isMe': true
        });
        _messageController.clear();
      });
    }
  }
}