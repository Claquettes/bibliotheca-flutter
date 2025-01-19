class Auteur {
  int? id;
  String? nom;
  String? prenoms;
  String? email;

  Auteur({this.id, this.nom, this.prenoms, this.email});

  // Convert JSON response to Auteur object safely
  factory Auteur.fromJson(Map<String, dynamic> json) {
    return Auteur(
      id: json['id'],
      nom: json['nom'] ?? "Nom inconnu", // Provide default value if null
      prenoms: json['prenoms'] ?? "Prénom inconnu", // Keep 'prenoms' field
      email: json['email'] ?? "Email non fourni",
    );
  }
}
