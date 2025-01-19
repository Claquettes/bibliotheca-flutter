import 'package:flutter/material.dart';
import '../database/dao.dart';

class ListeLivrePage extends StatefulWidget {
  @override
  _ListeLivrePageState createState() => _ListeLivrePageState();
}

class _ListeLivrePageState extends State<ListeLivrePage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> books;
  String errorMessage = "";

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
                return ListTile(
                  leading: Icon(Icons.book),
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
                  onTap: () {
                    Navigator.pushNamed(context, "/editBook", arguments: book);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/addBook");
        },
      ),
    );
  }
}
