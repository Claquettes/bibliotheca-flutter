import 'package:flutter/material.dart';
import '../database/dao.dart';
import 'edition_categorie.dart'; // Ensure this is imported

class ListeCategoriePage extends StatefulWidget {
  @override
  _ListeCategoriePageState createState() => _ListeCategoriePageState();
}

class _ListeCategoriePageState extends State<ListeCategoriePage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> categories;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    categories = fetchCategoriesWithDebug();
  }

  Future<List<dynamic>> fetchCategoriesWithDebug() async {
    try {
      print("Fetching categories from API...");
      List<dynamic> data = await apiService.fetchCategories();
      print("API Response: $data");
      return data;
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        errorMessage = e.toString();
      });
      return Future.error(e);
    }
  }

  void _navigateToEditPage(Map<String, dynamic>? category) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditionCategoriePage(category: category),
      ),
    );

    if (result == true) {
      setState(() {
        categories = fetchCategoriesWithDebug(); // Refresh list after editing
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des catégories")),
      body: FutureBuilder<List<dynamic>>(
        future: categories,
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
                        categories = fetchCategoriesWithDebug();
                      });
                    },
                    child: Text("Réessayer"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucune catégorie trouvée."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var category = snapshot.data![index];
                return ListTile(
                  title: Text(category["libelle"]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      apiService.deleteCategory(category["id"]).then((_) {
                        setState(() {
                          categories = fetchCategoriesWithDebug();
                        });
                      }).catchError((e) {
                        print("Error deleting category: $e");
                      });
                    },
                  ),
                  onTap: () => _navigateToEditPage(category), // Navigate to edit page
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
            MaterialPageRoute(builder: (context) => EditionCategoriePage()),
          ).then((result) {
            if (result == true) {
              setState(() {
                categories = fetchCategoriesWithDebug();
              });
            }
          });
        },
      ),
    );
  }
}
