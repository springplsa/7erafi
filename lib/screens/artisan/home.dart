import 'package:flutter/material.dart';
import 'package:start_up/screens/PostDetail.dart';
import 'package:start_up/screens/Profile.dart';
import 'package:start_up/screens/artisan/make_post.dart';
import 'package:start_up/screens/message.dart';
import 'package:start_up/screens/search.dart';

class Home extends StatefulWidget {
  const Home({super.key, required String tabName});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> 
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  final List<Map<String, dynamic>> posts = [
    {
      "image": "images/post1.jpeg",
      "description": "Une robe soirée",
      "likes": 120,
      "comments": 30,
      "user": "Fatima Couture",
      "userImage": "images/profile.jpg",
      "commentsList": [
        {"user": "Amel Drisi", "comment": "Très belle robe!", "time": "il y a 2h"}
      ]
    },
    {
      "image": "images/post2.jpeg",
      "description": "Une commande personnalisée",
      "likes": 200,
      "comments": 45,
      "user": "Maison Fati",
      "userImage": "images/profile.jpg",
      "commentsList": [
        {"user": "Fatima Abbas", "comment": "J'adore ce style", "time": "il y a 1h"}
      ]
    },
    {
      "image": "images/post3.jpeg",
      "description": "Une Abaya pour l'Eid",
      "likes": 150,
      "comments": 20,
      "user": "Design by Amina",
      "userImage": "images/profile.jpg",
      "commentsList": [
        {"user": "Mohamed Derar", "comment": "Parfait pour l'Eid", "time": "il y a 3h"}
      ]
    }
  ];
  
 

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void _onNavTapped(int index) async {
    if (index == 2) {
      final newPost = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CreatePostScreen()),
      );

      if (newPost != null) {
        setState(() {
          posts.insert(0, {
            "image": newPost['imageUrl'] ?? "images/default.jpg",
            "description": newPost['description'],
            "likes": 0,
            "comments": 0,
            "user": "Moi",
            "userImage": "images/profile.jpg",
            "commentsList": []
          });
        });
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeScreen(),
      const Search(),
      Container(), // placeholder for Add tab
      const ChatScreen(username: '', name: ''),
    const Profile(userImage: '', userName: '',),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        selectedItemColor: const Color(0xFFF8B3BB),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Rechercher"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Ajouter"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: "Pour toi"),
            Tab(text: "Abonnements"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostGrid(),
          _buildSubscriptionFeed(),
        ],
      ),
    );
  }

  Widget _buildPostGrid() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
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
              _showPostDetails(context, post);
            },
            child: buildPostCard(post),
          );
        },
      ),
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
                        IconButton(
                          icon: const Icon(Icons.favorite_border, 
                              color: Colors.red, size: 18),
                          onPressed: () {
                            setState(() {
                              post["likes"]++;
                            });
                          },
                        ),
                        Text("${post["likes"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.comment, 
                              color: Colors.grey, size: 18),
                          onPressed: () {
                            _showComments(context, post);
                          },
                        ),
                        Text("${post["comments"]}"),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, size: 18),
                      onPressed: () {
                        // Implement save functionality
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionFeed() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPostItem(
          post: posts[0], // Using the first post as example
        ),
        const Divider(height: 24),
        _buildPostItem(
          post: posts[1], // Using the second post as example
        ),
      ],
    );
  }

  Widget _buildPostItem({required Map<String, dynamic> post}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(post["userImage"]),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post["user"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "il y a 2h",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          post["description"],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            post["image"],
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      post["likes"]++;
                    });
                  },
                ),
                Text("${post["likes"]}"),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.grey),
                  onPressed: () {
                    _showComments(context, post);
                  },
                ),
                Text("${post["comments"]}"),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {
                // Implement save functionality
              },
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  void _showPostDetails(BuildContext context, Map<String, dynamic> post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetail(post: post),
      ),
    );
  }

  void _showComments(BuildContext context, Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Commentaires",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: post["commentsList"].length,
                  itemBuilder: (context, index) {
                    final comment = post["commentsList"][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment["user"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                comment["time"],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(comment["comment"]),
                        ],
                      ),
                    );
                  },
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Ajouter un commentaire...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Add comment functionality
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      post["commentsList"].insert(0, {
                        "user": "Moi",
                        "comment": value,
                        "time": "Maintenant"
                      });
                      post["comments"]++;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}