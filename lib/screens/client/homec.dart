import 'package:flutter/material.dart';
import 'package:start_up/screens/PostDetail.dart';
import 'package:start_up/screens/Profile.dart';
import 'package:start_up/screens/search.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<Map<String, dynamic>> posts = [
    {
      "image": "images/post1.jpeg",
      "description": "Une robe soirée",
      "likes": 120,
      "comments": 30,
      "user": "Fatima Couture"
    },
    {
      "image": "images/post2.jpeg",
      "description": "Une commande personnalisée",
      "likes": 200,
      "comments": 45,
      "user": "Maison Fati"
    },
    {
      "image": "images/post3.jpeg",
      "description": "Une Abaya pour l'Eid",
      "likes": 150,
      "comments": 20,
      "user": "Design by Amina"
    }
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildMainFeed(),       // Home
      const Search(),         // Search
      const Profile(userImage: '', userName: '',),        // Profile
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.pinkAccent,
                tabs: const [
                  Tab(text: "Pour toi"),
                  Tab(text: "Abonnements"),
                ],
              ),
            )
          : null,
      body: _currentIndex == 0
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildPostGrid(),
                const Center(child: Text("Contenu des abonnements")),
              ],
            )
          : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Rechercher"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildMainFeed() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _buildPostGrid(),
    );
  }

  Widget _buildPostGrid() {
    return GridView.builder(
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PostDetail(post: post)),
            );
          },
          child: buildPostCard(post),
        );
      },
    );
  }

  Widget buildPostCard(Map<String, dynamic> post) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                post["image"],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post["description"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, color: Colors.red, size: 18),
                        const SizedBox(width: 5),
                        Text("${post["likes"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.comment, color: Colors.grey, size: 18),
                        const SizedBox(width: 5),
                        Text("${post["comments"]}"),
                      ],
                    ),
                    const Icon(Icons.bookmark_border, size: 18),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
