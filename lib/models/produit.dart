class Produit {
  String libelle;
  String description;
  double prix;
  String photo;

  Produit({
    required this.libelle,
    required this.description,
    required this.prix,
    required this.photo,
  });

  // Empty constructor for form initialization
  Produit.empty() : libelle = '', description = '', prix = 0.0, photo = '';
}
