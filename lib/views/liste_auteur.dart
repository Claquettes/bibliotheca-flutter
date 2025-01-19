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
      appBar: AppBar(title: Text("Liste des auteurs")),
      body: FutureBuilder<List<Auteur>>(
        future: authors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun auteur trouvé."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var author = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(author.nom ?? "Nom inconnu"),
                  subtitle: Text(author.prenoms ?? "Prénom inconnu"),
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
                  onTap: () => _navigateToEditPage(author), // Navigate to edit page
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToEditPage(null); // Navigate to create new author
        },
      ),
    );
  }
}
