import 'dart:io';
import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetail({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isVente = post["type"] == "Vente";
    final isCommande = post["type"] == "Commande";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Publication"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          if (post["image"] != null)
            Image.file(File(post["image"]), fit: BoxFit.cover, width: double.infinity, height: 300),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(post["description"], style: const TextStyle(fontSize: 16)),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFF8B3BB),
              child: Text(post["user"][0]),
            ),
            title: Text(post["user"], style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Suivre"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8B3BB),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const Divider(),
          if (isVente) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Prix: ${post["price"]} DA", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Paiement: ${post["payment"]}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Livraison: ${post["delivery"]}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Acheter"),
                  ),
                ],
              ),
            ),
          ] else if (isCommande) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Commander"),
              ),
            )
          ],
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Commentaires", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text("Superbe robe !"),
            subtitle: const Text("Il y a 1 heure"),
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text("J'adore le design !"),
            subtitle: const Text("Il y a 30 min"),
          ),
        ],
      ),
    );
  }
}
