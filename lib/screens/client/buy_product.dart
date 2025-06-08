import 'package:flutter/material.dart';
class Buy extends StatelessWidget {
  const Buy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails du produit")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Text("Prix: 15000 DA"),
            Text("Méthode de paiement: à la livraison"),
            Text("Méthode de livraison: domicile"),
            Text("Date de livraison estimée: 3 jours"),
            SizedBox(height: 20),
            ElevatedButton(onPressed: null, child: Text("Confirmer l'achat")),
          ],
        ),
      ),
    );
  }
}

