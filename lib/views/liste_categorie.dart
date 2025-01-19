import 'package:flutter/material.dart';
import '../database/dao.dart';

class ListeCategoriePage extends StatefulWidget {
  @override
  _ListeCategoriePageState createState() => _ListeCategoriePageState();
}

class _ListeCategoriePageState extends State<ListeCategoriePage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> categories;

  @override
  void initState() {
    super.initState();
    categories = apiService.fetchCategories();
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
            return Center(child: Text("Erreur de chargement"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var category = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.category),
                  title: Text(category['libelle']),
                  onTap: () {},
                );
              },
            );
          }
        },
      ),
    );
  }
}
