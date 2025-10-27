import 'package:flutter/material.dart';
import 'produit_box.dart';

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  final TextEditingController _textController = TextEditingController();
  
  List<String> produits = [
    "1 produit",
    "2 produit",
    "3 produit",
    "4 produit",
    "5 produit"
  ];

  Map<String, bool> selProduits = {};

  @override
  void initState() {
    super.initState();
    for (var produit in produits) {
      selProduits[produit] = false;
    }
  }

  void selectionProduit(String nom) {
    setState(() {
      selProduits[nom] = !selProduits[nom]!;
    });
  }

  void ajoutProduit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un produit"),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: "Nom du produit",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  produits.add(_textController.text);
                  selProduits[_textController.text] = false;
                });
                _textController.clear();
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  void supprimerProduit(String nom) {
    setState(() {
      produits.remove(nom);
      selProduits.remove(nom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produits"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ajoutProduit,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: produits.length,
        itemBuilder: (context, index) {
          String produit = produits[index];
          return ProduitBox(
            nomProduit: produit,
            selProduit: selProduits[produit]!,
            onChanged: () {
              selectionProduit(produit);
            },
            delProduit: () {
              supprimerProduit(produit);
            },
          );
        },
      ),
    );
  }
}
