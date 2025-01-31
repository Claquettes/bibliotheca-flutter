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

  final Color backgroundColor = Color(0xFF24273A);
  final Color cardColor = Color(0xFF363A4F);
  final Color textColor = Color(0xFFCAD3F5);
  final Color primaryColor = Color(0xFF8AADF4);

  @override
  void initState() {
    super.initState();
    categories = apiService.fetchCategories();
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
        categories = apiService.fetchCategories(); // Refresh list after editing
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Liste des catégories"),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement: ${snapshot.error}", style: TextStyle(color: textColor)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucune catégorie trouvée.", style: TextStyle(color: textColor)));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var category = snapshot.data![index];
                return Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(category["libelle"], style: TextStyle(color: textColor)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        apiService.deleteCategory(category["id"]).then((_) {
                          setState(() {
                            categories = apiService.fetchCategories();
                          });
                        }).catchError((e) {
                          print("Error deleting category: $e");
                        });
                      },
                    ),
                    onTap: () => _navigateToEditPage(category),
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
          _navigateToEditPage(null);
        },
      ),
    );
  }
}
