import 'package:flutter/material.dart';
import 'user_products_list.dart';
import 'favorites_screen.dart';
import 'user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    UserProductsList(),
    FavoritesScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<UserRoleProvider>(context).role;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil Utilisateur'),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Chip(
              label: Text(
                role == 'admin' ? 'ADMIN' : 'USER',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
