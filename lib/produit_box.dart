import 'package:flutter/material.dart';

class ProduitBox extends StatelessWidget {
  const ProduitBox({
    super.key, 
    required this.nomProduit,
    required this.selProduit,
    required this.onChanged
  });
  
  final String nomProduit;
  final bool selProduit;
  final Function onChanged;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Row(
        children: [
          Checkbox(
            value: selProduit,
            onChanged: (bool? value) {
              onChanged(value);
            },
          ),
          Text(nomProduit),
        ],
      ),
    );
  }
}