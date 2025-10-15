import 'package:flutter/material.dart';
import 'produit_box.dart';

class ProduitsList extends StatelessWidget {
  const ProduitsList({super.key});

  final List liste = const [
    ["1 produit",false],
    ["2 produit",false],
    ["3 produit",false],
    ["4 produit",false],
    ["5 produit",false]
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
          return ProduitBox(nomProduit: liste[index][0]);
        },
      ),
    );
   
  }
}
