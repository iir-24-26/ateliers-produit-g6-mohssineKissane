import 'package:flutter/material.dart';

class ProduitBox extends StatelessWidget {
  const ProduitBox({super.key, required this.nomProduit});
  
  final String nomProduit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Text(nomProduit)
    );
  }
}