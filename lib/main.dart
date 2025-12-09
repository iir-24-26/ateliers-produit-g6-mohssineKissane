import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'firebase_options.dart';
import 'login_ecran.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRoleProvider extends ChangeNotifier {
  String? _role;
  String? get role => _role;
  set role(String? value) {
    _role = value;
    notifyListeners();
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserRoleProvider(),
      child: const MainApp(),
    ),
  );
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginEcran(),
    );
  }
}


// scaffold va utilise listview , et listview va utilise produitbox