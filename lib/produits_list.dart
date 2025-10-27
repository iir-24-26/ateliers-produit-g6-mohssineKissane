import 'package:flutter/material.dart';
import 'produit_box.dart';

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produits"),
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
          );
        },
      ),
    );
  }
}
