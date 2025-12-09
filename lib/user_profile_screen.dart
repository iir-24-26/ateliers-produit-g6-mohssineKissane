import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final role = Provider.of<UserRoleProvider>(context).role;
    if (user == null) {
      return const Center(child: Text('Non connecté.'));
    }
    final favsRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('favorites');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 48, color: Colors.green),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(role == 'admin' ? 'ADMIN' : 'USER', style: const TextStyle(color: Colors.white)),
                    backgroundColor: role == 'admin' ? Colors.blue : Colors.green,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          StreamBuilder<QuerySnapshot>(
            stream: favsRef.snapshots(),
            builder: (context, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              return Text('Favoris: $count', style: const TextStyle(fontSize: 16));
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Déconnexion'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
