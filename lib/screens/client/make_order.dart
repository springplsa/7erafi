import 'package:flutter/material.dart';
class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commander")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Date de livraison"),
            ),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Message au vendeur"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Send order to backend
              },
              child: const Text("Envoyer la commande"),
            ),
          ],
        ),
      ),
    );
  }
}

