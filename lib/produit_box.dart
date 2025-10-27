import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProduitBox extends StatelessWidget {
  const ProduitBox({
    super.key, 
    required this.nomProduit,
    required this.selProduit,
    required this.onChanged,
    required this.delProduit
  });
  
  final String nomProduit;
  final bool selProduit;
  final Function onChanged;
  final Function delProduit;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  delProduit();
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Supprimer',
              ),
            ],
          ),
          child: Container(
            height: 100,
            child: Card(
              child: Row(
                children: [
                  Text(nomProduit),
                  Checkbox(
                    value: selProduit,
                    onChanged: (val) {
                      onChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}