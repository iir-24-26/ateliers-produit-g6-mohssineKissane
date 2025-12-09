import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'produits_list.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'admin_home_screen.dart';
import 'user_home_screen.dart';


class LoginEcran extends StatelessWidget {
  const LoginEcran({super.key});

  Future<void> _ensureUserDoc(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await userDoc.get();
    if (!doc.exists) {
      await userDoc.set({
        'email': user.email,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: (() async {
              await _ensureUserDoc(user);
              return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
            })(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (userSnapshot.hasError || !userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Scaffold(
                  body: Center(child: Text('Erreur de chargement du profil utilisateur.')),
                );
              }
              final data = userSnapshot.data!.data()!;
              final role = data['role'] ?? 'user';
              // Store role in Provider
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<UserRoleProvider>(context, listen: false).role = role;
              });
              // Navigation logic (replace with your admin/user screens)
              if (role == 'admin') {
                return const AdminHomeScreen();
              } else {
                return const UserHomeScreen();
              }
            },
          );
        }

        // If user is NOT authenticated - show sign in screen
        return SignInScreen(
          providers: [
            EmailAuthProvider(),
          ],
          headerBuilder: (context, constraints, shrinkOffset) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: 1,
                child: Icon(
                  Icons.shopping_cart,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
          subtitleBuilder: (context, action) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: action == AuthAction.signIn
                  ? const Text('Bienvenue! Veuillez vous connecter.')
                  : const Text('Bienvenue! Veuillez créer un compte.'),
            );
          },
          footerBuilder: (context, action) {
            return const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'En vous connectant, vous acceptez nos conditions d\'utilisation.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          },
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {}),
            AuthStateChangeAction<UserCreated>((context, state) {}),
          ],
        );
      },
    );
  }
}
