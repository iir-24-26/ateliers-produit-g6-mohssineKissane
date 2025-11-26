import 'package:flutter/material.dart';
import 'produits_list.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ProduitsList(),
    );
  }
}


// scaffold va utilise listview , et listview va utilise produitbox
