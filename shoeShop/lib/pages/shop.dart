import 'package:flutter/material.dart';
import '../models/schoen.dart';

class ShopPage extends StatelessWidget {
  final List<Schoen> winkelwagen;

  const ShopPage({required this.winkelwagen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Winkelwagen'),
      ),
      body: winkelwagen.isEmpty
          ? const Center(
              child: Text(
                'Je winkelwagen is leeg!',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: winkelwagen.length,
                    itemBuilder: (context, index) {
                      final schoen = winkelwagen[index];
                      return ListTile(
                        title: Text(schoen.naam),
                        subtitle: Text("€${schoen.prijs.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            winkelwagen.removeAt(index);
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Totaal: €${winkelwagen.fold(0.0, (sum, item) => sum + item.prijs).toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (winkelwagen.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Bestelling geplaatst!'),
                                content: const Text('Bedankt voor je aankoop.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      winkelwagen.clear();
                                      Navigator.of(context).pop();
                                      (context as Element).markNeedsBuild();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text('Afrekenen'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: const TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
