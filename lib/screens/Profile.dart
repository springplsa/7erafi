import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String userImage;
  final String userName;

  const Profile({
    super.key,
    required this.userImage,
    required this.userName,
  });

  final List<Map<String, dynamic>> posts = const [
    {"image": "images/post1.jpeg", "description": "Robe soiree"},
    {"image": "images/post2.jpeg", "description": "Commande personnalisée"},
    {"image": "images/post3.jpeg", "description": "Abaya Eid"},
    {"image": "images/post1.jpeg", "description": "Stylé et moderne"},
    {"image": "images/post2.jpeg", "description": "Élégant"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _openSettingsDrawer(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            ),
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

  void _openSettingsDrawer(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Paramètres",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildSettingsOption(
                      icon: Icons.person,
                      title: "Gestion de compte",
                      onTap: () => _navigateToAccountManagement(context),
                    ),
                    _buildSettingsOption(
                      icon: Icons.settings,
                      title: "Configuration de l'app",
                      onTap: () => _navigateToAppConfiguration(context),
                    ),
                    _buildSettingsOption(
                      icon: Icons.security,
                      title: "Permissions",
                      onTap: () => _navigateToPermissions(context),
                    ),
                    const Divider(),
                    _buildSettingsOption(
                      icon: Icons.logout,
                      title: "Déconnexion",
                      onTap: () => _logout(context),
                    ),
                    _buildSettingsOption(
                      icon: Icons.add,
                      title: "Ajouter un compte",
                      onTap: () => _addAccount(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(userImage),
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const Icon(Icons.star, color: Colors.amber, size: 20),
            Icon(Icons.star_half, color: Colors.amber, size: 20),
            const SizedBox(width: 5),
            const Text("4.5", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStat("Publications", "45"),
          _buildStat("Abonnés", "1.2k"),
          _buildStat("Abonnements", "300"),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildBio(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Styliste passionnée, spécialisée en couture traditionnelle et moderne.✨",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8B3BB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("S'abonner"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(color: Color(0xFFF8B3BB)),
              ),
              child: const Text(
                "Envoyer message",
                style: TextStyle(color: Color(0xFFF8B3BB)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        "Posts",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              post["image"],
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              post["description"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAccountManagement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountManagementScreen()),
    );
  }

  void _navigateToAppConfiguration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppConfigurationScreen()),
    );
  }

  void _navigateToPermissions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PermissionsScreen()),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pop(context);
  }

  void _addAccount(BuildContext context) {
    Navigator.pop(context);
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: const Center(child: Text("Notifications Screen")),
    );
  }
}

class AccountManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion de compte")),
      body: const Center(child: Text("Account Management Screen")),
    );
  }
}

class AppConfigurationScreen extends StatefulWidget {
  @override
  State<AppConfigurationScreen> createState() => _AppConfigurationScreenState();
}

class _AppConfigurationScreenState extends State<AppConfigurationScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuration de l'app")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Mode sombre"),
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
            ),
            SwitchListTile(
              title: const Text("Notifications"),
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
            ),
            const ListTile(
              title: Text("Langue"),
              subtitle: Text("Français"),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permissions")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text("Localisation"),
              subtitle: Text("Accès à votre position"),
            ),
            ListTile(
              title: Text("Wifi"),
              subtitle: Text("Accès aux informations de connexion"),
            ),
            ListTile(
              title: Text("Média"),
              subtitle: Text("Accès aux photos et fichiers multimédias"),
            ),
          ],
        ),
      ),
    );
  }
}
