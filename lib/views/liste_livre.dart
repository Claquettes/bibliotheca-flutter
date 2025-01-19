import 'package:flutter/material.dart';
import '../database/dao.dart';
import 'edition_livre.dart'; // Ensure this is imported

class ListeLivrePage extends StatefulWidget {
  @override
  _ListeLivrePageState createState() => _ListeLivrePageState();
}

class _ListeLivrePageState extends State<ListeLivrePage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> books;
  String errorMessage = "";
  final String fallbackImage = "https://www.kittyinny.com/uploads/8/8/2/5/8825228/8079341_orig.jpg";

  @override
  void initState() {
    super.initState();
    books = fetchBooksWithDebug();
  }

  Future<List<dynamic>> fetchBooksWithDebug() async {
    try {
      print("Fetching books from API...");
      List<dynamic> data = await apiService.fetchBooks();
      print("API Response: $data");
      return data;
    } catch (e) {
      print("Error fetching books: $e");
      setState(() {
        errorMessage = e.toString();
      });
      return Future.error(e);
    }
  }

  void _navigateToEditPage(Map<String, dynamic> book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditionLivrePage(book: book),
      ),
    );

    if (result == true) {
      setState(() {
        books = fetchBooksWithDebug(); // Refresh list after editing
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des livres")),
      body: FutureBuilder<List<dynamic>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Erreur de chargement", style: TextStyle(color: Colors.red)),
                  SizedBox(height: 10),
                  Text(errorMessage, textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        books = fetchBooksWithDebug();
                      });
                    },
                    child: Text("Réessayer"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun livre trouvé."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var book = snapshot.data![index];
                String imageUrl = (book["image"] != null && book["image"].toString().isNotEmpty)
                    ? book["image"]
                    : fallbackImage; // Use fallback image if the URL is invalid

                return ListTile(
                  leading: Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(fallbackImage, width: 50, height: 50, fit: BoxFit.cover);
                    },
                  ),
                  title: Text(book["libelle"]),
                  subtitle: Text(book["description"] ?? "Pas de description"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      apiService.deleteBook(book["id"]).then((_) {
                        setState(() {
                          books = fetchBooksWithDebug();
                        });
                      }).catchError((e) {
                        print("Error deleting book: $e");
                      });
                    },
                  ),
                  onTap: () => _navigateToEditPage(book), // Navigate to edit page
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditionLivrePage()),
          ).then((result) {
            if (result == true) {
              setState(() {
                books = fetchBooksWithDebug();
              });
            }
          });
        },
      ),
    );
  }
}
