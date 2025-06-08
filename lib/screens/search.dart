import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Tous';

  // Dummy data (replace with your real data source)
  final List<Map<String, String>> _artisans = [
    {"name": "Fatima", "category": "Couture"},
    {"name": "Ahmed", "category": "Cuisine"},
    {"name": "Khadija", "category": "Peinture"},
    {"name": "Yassine", "category": "Electricité"},
    {"name": "Amina", "category": "Cuisine"},
    {"name": "Sami", "category": "Couture"},
  ];

  final List<String> _categories = [
    "Tous",
    "Couture",
    "Cuisine",
    "Peinture",
    "Electricité",
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> filteredArtisans = _artisans.where((artisan) {
      final nameMatch = artisan["name"]!.toLowerCase().contains(_searchQuery.toLowerCase());
      final categoryMatch = _selectedCategory == "Tous" || artisan["category"] == _selectedCategory;
      return nameMatch && categoryMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recherche", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Rechercher un artisan",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🧰 Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = category),
                    selectedColor: const Color(0xFFF8B3BB),
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // 📋 Results
          Expanded(
            child: filteredArtisans.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredArtisans.length,
                    itemBuilder: (_, index) {
                      final artisan = filteredArtisans[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(artisan["name"]!),
                        subtitle: Text("Catégorie: ${artisan["category"]}"),
                        onTap: () {
                          // TODO: Navigate to profile or messaging
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "Aucun résultat trouvé.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
