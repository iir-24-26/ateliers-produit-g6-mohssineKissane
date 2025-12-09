import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'models/produit.dart';

import 'add_produit_form.dart';
import 'produit_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  void ajoutProduit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProduitForm(onAddProduit: (_) {}),
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('produits').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement: \\n${snapshot.error}'));
          }
          final produitsDocs = snapshot.data?.docs ?? [];
          if (produitsDocs.isEmpty) {
            return const Center(
              child: Text(
                'Aucun produit. Cliquez sur + pour en ajouter.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: produitsDocs.length,
            itemBuilder: (context, index) {
              final doc = produitsDocs[index];
              final data = doc.data();
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: data['photo'] != null && data['photo'].toString().isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.network(
                                  data['photo'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error),
                                    );
                                  },
                                )
                              : Image.file(
                                  File(data['photo']),
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
                    data['libelle'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${(data['prix'] ?? 0).toString()} €'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Supprimer le produit'),
                          content: const Text('Voulez-vous vraiment supprimer ce produit ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          await FirebaseFirestore.instance.collection('produits').doc(doc.id).delete();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Produit supprimé avec succès!')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur lors de la suppression: $e')),
                          );
                        }
                      }
                    },
                  ),
                  onTap: () {
                    // TODO: Pass Firestore data to details screen if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
