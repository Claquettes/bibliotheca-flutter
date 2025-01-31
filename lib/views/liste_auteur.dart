import 'package:flutter/material.dart';
import '../database/dao.dart';
import '../models/auteur.dart'; // Import Auteur model
import 'edition_auteur.dart'; // Import Edit/Create Page

class ListeAuteurPage extends StatefulWidget {
  @override
  _ListeAuteurPageState createState() => _ListeAuteurPageState();
}

class _ListeAuteurPageState extends State<ListeAuteurPage> {
  final ApiService apiService = ApiService();
  late Future<List<Auteur>> authors;

  final Color backgroundColor = Color(0xFF24273A);
  final Color cardColor = Color(0xFF363A4F);
  final Color textColor = Color(0xFFCAD3F5);
  final Color primaryColor = Color(0xFF8AADF4);

  @override
  void initState() {
    super.initState();
    authors = apiService.fetchAuthors();
  }

  void _navigateToEditPage(Auteur? author) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditionAuteurPage(author: author),
      ),
    );

    if (result == true) {
      setState(() {
        authors = apiService.fetchAuthors(); // Refresh list after editing
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Liste des auteurs"),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<Auteur>>(
        future: authors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement: ${snapshot.error}", style: TextStyle(color: textColor)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun auteur trouvé.", style: TextStyle(color: textColor)));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var author = snapshot.data![index];
                return Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.person, color: primaryColor),
                    title: Text(author.nom ?? "Nom inconnu", style: TextStyle(color: textColor)),
                    subtitle: Text(author.prenoms ?? "Prénom inconnu", style: TextStyle(color: textColor)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        apiService.deleteAuthor(author.id!).then((_) {
                          setState(() {
                            authors = apiService.fetchAuthors();
                          });
                        }).catchError((e) {
                          print("Error deleting author: $e");
                        });
                      },
                    ),
                    onTap: () => _navigateToEditPage(author),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: backgroundColor),
        onPressed: () {
          _navigateToEditPage(null); // Navigate to create new author
        },
      ),
    );
  }
}
