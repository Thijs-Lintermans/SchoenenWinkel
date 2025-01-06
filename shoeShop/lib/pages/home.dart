import 'package:flutter/material.dart';
import '../models/schoen.dart';
import '../apis/schoen_api.dart';
import 'details.dart';
import 'favorieten.dart';
import 'shop.dart';
import 'ar_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Schoen> schoenLijst = [];
  List<Schoen> favorieten = [];
  List<Schoen> winkelwagen = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _haalSchoenenOp();
  }

  Future<void> _haalSchoenenOp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final resultaat = await SchoenApi.fetchSchoenen();
      setState(() {
        schoenLijst = resultaat;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Kan geen schoenen laden. Controleer uw verbinding.';
      });
    }
  }

  void _toggleFavoriet(Schoen schoen) {
    setState(() {
      if (favorieten.contains(schoen)) {
        favorieten.remove(schoen);
      } else {
        favorieten.add(schoen);
      }
    });
  }

  void _voegToeAanWinkelwagen(Schoen schoen) {
    setState(() {
      if (!winkelwagen.contains(schoen)) {
        winkelwagen.add(schoen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schoenen Collectie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavouritesPage(
                    favorieten: favorieten,
                    winkelwagen: winkelwagen,
                  ),
                ),
              );
            },
          ),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : schoenLijst.isEmpty
                  ? const Center(child: Text('Geen schoenen gevonden.'))
                  : ListView.builder(
                      itemCount: schoenLijst.length,
                      itemBuilder: (BuildContext context, int positie) {
                        final schoen = schoenLijst[positie];
                        return Card(
                          elevation: 2.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(schoen.imageUrl),
                              backgroundColor: Colors.grey[200],
                            ),
                            title: Text(schoen.naam),
                            subtitle: Text("Merk: ${schoen.merk}"),
                            trailing: IconButton(
                              icon: Icon(
                                favorieten.contains(schoen)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favorieten.contains(schoen)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: () => _toggleFavoriet(schoen),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(schoen: schoen, winkelwagen: [ ],),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArPage()),
          );
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
