import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'models/produit.dart';
import 'add_produit_form.dart';
import 'produit_details.dart';

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  List<Produit> produits = [];

  void saveProduit(Produit produit) {
    setState(() {
      produits.add(produit);
    });
  }

  void supprimerProduit(int index) {
    setState(() {
      produits.removeAt(index);
    });
  }

  void ajoutProduit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProduitForm(onAddProduit: saveProduit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produits")),
      floatingActionButton: FloatingActionButton(
        onPressed: ajoutProduit,
        child: const Icon(Icons.add),
      ),
      body:
          produits.isEmpty
              ? const Center(
                child: Text(
                  'Aucun produit. Cliquez sur + pour en ajouter.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: produits.length,
                itemBuilder: (context, index) {
                  Produit produit = produits[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading:
                          produit.photo.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    kIsWeb
                                        ? Image.network(
                                          produit.photo,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.error),
                                            );
                                          },
                                        )
                                        : Image.file(
                                          File(produit.photo),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                              )
                              : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                ),
                              ),
                      title: Text(
                        produit.libelle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${produit.prix.toStringAsFixed(2)} €'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          supprimerProduit(index);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProduitDetails(produit: produit),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
