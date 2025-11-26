class Produit {
  int? id;
  String libelle;
  String description;
  double prix;
  String photo;

  Produit({
    this.id,
    required this.libelle,
    required this.description,
    required this.prix,
    required this.photo,
  });

  // Empty constructor for form initialization
  Produit.empty()
      : id = null,
        libelle = '',
        description = '',
        prix = 0.0,
        photo = '';

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'prix': prix,
      'photo': photo,
    };
  }

  // Create from Map from database
  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map['id'] as int?,
      libelle: map['libelle'] as String,
      description: map['description'] as String,
      prix: map['prix'] as double,
      photo: map['photo'] as String,
    );
  }
}
