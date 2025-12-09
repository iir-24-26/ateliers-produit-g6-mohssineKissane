import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Non connecté.'));
    }
    final favsRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('favorites');
    return StreamBuilder<QuerySnapshot>(
      stream: favsRef.orderBy('timestamp', descending: true).snapshots(),
      builder: (context, favSnapshot) {
        if (favSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (favSnapshot.hasError) {
          return Center(child: Text('Erreur: ${favSnapshot.error}'));
        }
        final favDocs = favSnapshot.data?.docs ?? [];
        if (favDocs.isEmpty) {
          return const Center(child: Text('Aucun favori.'));
        }
        return ListView.builder(
          itemCount: favDocs.length,
          itemBuilder: (context, index) {
            final favDoc = favDocs[index];
            final productId = favDoc.id;
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection('produits').doc(productId).get(),
              builder: (context, prodSnapshot) {
                if (!prodSnapshot.hasData || !prodSnapshot.data!.exists) {
                  return const SizedBox();
                }
                final data = prodSnapshot.data!.data()!;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: data['photo'] != null && data['photo'].toString().isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: data['photo'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              ),
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
                    title: Text(data['libelle'] ?? ''),
                    subtitle: Text('${(data['prix'] ?? 0).toString()} €'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await favDoc.reference.delete();
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
