import 'package:flutter/material.dart';
import 'produit_box.dart';

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  List liste = [
    ["1 produit", false],
    ["2 produit", false],
    ["3 produit", false],
    ["4 produit", false],
    ["5 produit", false]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produits"),
      ),
      body: ListView.builder(
        itemCount: liste.length,
        itemBuilder: (context, index) {
          return ProduitBox(
            nomProduit: liste[index][0],
            selProduit: liste[index][1],
            onChanged: (bool? value) {
              setState(() {
                liste[index][1] = value ?? false;
              });
            },
          );
        },
      ),
    );
  }
}
