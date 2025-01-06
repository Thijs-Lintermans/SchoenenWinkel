import 'package:flutter/material.dart';
import '../models/schoen.dart';
import '../apis/schoen_api.dart';
import 'shop.dart';

class DetailsPage extends StatelessWidget {
  final Schoen schoen;
  final List<Schoen> winkelwagen;

  const DetailsPage({required this.schoen, required this.winkelwagen, Key? key}) : super(key: key);

  void voegToeAanWinkelwagen(BuildContext context) {
    if (!winkelwagen.contains(schoen)) {
      winkelwagen.add(schoen);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${schoen.naam} is toegevoegd aan je winkelwagen!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${schoen.naam} zit al in je winkelwagen!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schoen.naam),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopPage(winkelwagen: winkelwagen),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(schoen.imageUrl, height: 250, width: 250),
              const SizedBox(height: 20),
              Text(schoen.naam, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Merk: ${schoen.merk}", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              Text('Prijs: €${schoen.prijs.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, color: Colors.green)),
              const SizedBox(height: 16),
              Text(schoen.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => voegToeAanWinkelwagen(context),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Toevoegen aan winkelwagen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
