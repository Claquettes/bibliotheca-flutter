import 'package:flutter/material.dart';
import '../database/dao.dart';

class ListeAuteurPage extends StatefulWidget {
  @override
  _ListeAuteurPageState createState() => _ListeAuteurPageState();
}

class _ListeAuteurPageState extends State<ListeAuteurPage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> authors;

  @override
  void initState() {
    super.initState();
    authors = apiService.fetchAuthors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des auteurs")),
      body: FutureBuilder<List<dynamic>>(
        future: authors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var author = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(author['nom']),
                  subtitle: Text(author['prenom']),
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
