import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProductsList extends StatelessWidget {
  const UserProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('produits').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement: \n${snapshot.error}'));
        }
        final produitsDocs = snapshot.data?.docs ?? [];
        if (produitsDocs.isEmpty) {
          return const Center(
            child: Text(
              'Aucun produit disponible.',
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
                title: Text(
                  data['libelle'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${(data['prix'] ?? 0).toString()} €'),
                trailing: FavoriteButton(productId: doc.id),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final String productId;
  const FavoriteButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();
    final favRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('favorites').doc(productId);
    return StreamBuilder<DocumentSnapshot>(
      stream: favRef.snapshots(),
      builder: (context, snapshot) {
        final isFav = snapshot.data?.exists ?? false;
        return IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
          onPressed: () async {
            if (isFav) {
              await favRef.delete();
            } else {
              await favRef.set({'timestamp': FieldValue.serverTimestamp()});
            }
          },
        );
      },
    );
  }
}
