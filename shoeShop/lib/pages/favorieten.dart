import 'package:flutter/material.dart';
import '../models/schoen.dart';
import 'details.dart';
import 'shop.dart';

class FavouritesPage extends StatelessWidget {
  final List<Schoen> favorieten;
  final List<Schoen> winkelwagen;

  const FavouritesPage({
    required this.favorieten,
    required this.winkelwagen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriete Schoenen'),
      ),
      body: favorieten.isEmpty
          ? const Center(
              child: Text(
                'Je hebt nog geen favoriete schoenen!',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: favorieten.length,
                    itemBuilder: (context, index) {
                      final schoen = favorieten[index];
                      return ListTile(
                        title: Text(schoen.naam),
                        subtitle: Text("€${schoen.prijs.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            if (!winkelwagen.contains(schoen)) {
                              winkelwagen.add(schoen);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${schoen.naam} toegevoegd aan winkelwagen!'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${schoen.naam} zit al in de winkelwagen!'),
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(schoen: schoen, winkelwagen: [],),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopPage(winkelwagen: winkelwagen),
                        ),
                      );
                    },
                    child: const Text('Ga naar winkelwagen'),
                  ),
                ),
              ],
            ),
    );
  }
}
