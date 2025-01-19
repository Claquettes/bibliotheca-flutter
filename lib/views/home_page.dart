import 'package:flutter/material.dart';
import 'liste_livre.dart';
import 'liste_categorie.dart';
import 'liste_auteur.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenue sur Bibliotheca")),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildMenuButton("Livres", Icons.book, context, ListeLivrePage()),
          _buildMenuButton("Catégories", Icons.category, context, ListeCategoriePage()),
          _buildMenuButton("Auteurs", Icons.person, context, ListeAuteurPage()),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, IconData icon, BuildContext context, Widget page) {
    return MaterialButton(
      textColor: Colors.blue,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 17)),
        ],
      ),
    );
  }
}
