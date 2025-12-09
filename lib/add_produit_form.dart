import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduitForm extends StatefulWidget {
  final Function(Produit) onAddProduit;

  const AddProduitForm({super.key, required this.onAddProduit});

  @override
  State<AddProduitForm> createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {
  final _formKey = GlobalKey<FormState>();
  final Produit _produit = Produit.empty();
  String _pickedImagePath = '';
  XFile? _pickedImageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImagePath = image.path;
        _pickedImageFile = image;
        _produit.photo = image.path;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseFirestore.instance.collection('produits').add({
          'libelle': _produit.libelle,
          'description': _produit.description,
          'prix': _produit.prix,
          'photo': _produit.photo,
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produit ajouté avec succès!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un produit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Libellé',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un libellé';
                  }
                  return null;
                },
                onSaved: (value) {
                  _produit.libelle = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _produit.description = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                  suffixText: '€',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
                onSaved: (value) {
                  _produit.prix = double.parse(value!);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Choisir une image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              if (_pickedImagePath.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        kIsWeb
                            ? Image.network(
                              _pickedImagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                );
                              },
                            )
                            : Image.file(
                              File(_pickedImagePath),
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Ajouter le produit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
