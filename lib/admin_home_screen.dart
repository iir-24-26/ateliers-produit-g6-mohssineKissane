import 'package:flutter/material.dart';
import 'produits_list.dart';
import 'add_produit_form.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ProduitsList(),
    // Add more admin pages if needed
  ];

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<UserRoleProvider>(context).role;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Chip(
              label: Text(
                role == 'admin' ? 'ADMIN' : 'USER',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
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
          // Add more items for other admin features
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProduitForm(onAddProduit: (_) {}),
                  ),
                );
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }
}
