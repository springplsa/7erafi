import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  final List<Map<String, dynamic>> posts = const [
    {"image": "images/post1.jpeg", "description": "Robe soiree"},
    {"image": "images/post2.jpeg", "description": "Commande personnalisée"},
    {"image": "images/post3.jpeg", "description": "Abaya Eid"},
    {"image": "images/post1.jpeg", "description": "Stylé et moderne"},
    {"image": "images/post2.jpeg", "description": "Élégant"},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

Future<void> fetchUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final userId = prefs.getString('user_id')?.trim();


  if (token == null || userId == null) {
    print("⚠️ Token or userId is null — cannot fetch profile.");
    // Optional: show a snackbar or redirect to login
    return;
  }

  final url = Uri.parse('https://artisant.onrender.com/v1/user/$userId');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    setState(() {
      _user = jsonDecode(response.body);
      _isLoading = false;
    });
  } else {
    print("❌ Error: ${response.statusCode} - ${response.body}");
  }
}


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
          onPressed: () => _openSettingsDrawer(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              // Replace with your NotificationsScreen navigation
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildStats(context)),
            SliverToBoxAdapter(child: _buildBio(context)),
            SliverToBoxAdapter(child: _buildActionButtons()),
            SliverToBoxAdapter(child: _buildPostsHeader()),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPostCard(posts[index]),
                  childCount: posts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(radius: 40, backgroundImage: AssetImage('images/avatar.jpeg')),
        const SizedBox(height: 10),
        Text(
          "${_user?['firstName'] ?? ''} ${_user?['lastName'] ?? ''}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          _user?['email'] ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Column(children: [Text("120", style: TextStyle(fontWeight: FontWeight.bold)), Text("Publications")]),
          Column(children: [Text("300", style: TextStyle(fontWeight: FontWeight.bold)), Text("Abonnés")]),
          Column(children: [Text("180", style: TextStyle(fontWeight: FontWeight.bold)), Text("Suivis")]),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Ceci est une petite biographie. Vous pouvez personnaliser cela pour l'utilisateur.",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        children: [
          Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Modifier Profil"))),
          const SizedBox(width: 10),
          ElevatedButton(onPressed: () {}, child: const Icon(Icons.settings)),
        ],
      ),
    );
  }

  Widget _buildPostsHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text("Publications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage(post['image']), fit: BoxFit.cover)),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          padding: const EdgeInsets.all(4),
          child: Text(post['description'], style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _openSettingsDrawer(BuildContext context) {
    // Keep your existing drawer logic here
  }
}
