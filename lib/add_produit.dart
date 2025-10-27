import 'package:flutter/material.dart';

class AddProduit extends StatelessWidget {
  const AddProduit({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter un produit"),
      content: TextField(
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
            Navigator.pop(context, "nom_produit");
          },
          child: const Text("Ajouter"),
        ),
      ],
    );
  }
}
