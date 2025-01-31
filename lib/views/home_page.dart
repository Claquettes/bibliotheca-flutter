import 'package:flutter/material.dart';
import 'liste_livre.dart';
import 'liste_categorie.dart';
import 'liste_auteur.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color backgroundColor = Color(0xFF24273A); // Catppuccin Macchiato base
  final Color cardColor = Color(0xFF363A4F);
  final Color textColor = Color(0xFFCAD3F5);
  final Color primaryColor = Color(0xFF8AADF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Bienvenue sur Bibliotheca"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuButton("Livres", Icons.book, context, ListeLivrePage()),
            _buildMenuButton("Catégories", Icons.category, context, ListeCategoriePage()),
            _buildMenuButton("Auteurs", Icons.person, context, ListeAuteurPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String title, IconData icon, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: primaryColor),
            SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
      ),
    );
  }
}
