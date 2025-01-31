import 'package:flutter/material.dart';
import '../database/dao.dart';
import 'edition_livre.dart';

class ListeLivrePage extends StatefulWidget {
  @override
  _ListeLivrePageState createState() => _ListeLivrePageState();
}

class _ListeLivrePageState extends State<ListeLivrePage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> books;

  final Color backgroundColor = Color(0xFF24273A);
  final Color cardColor = Color(0xFF363A4F);
  final Color textColor = Color(0xFFCAD3F5);
  final Color primaryColor = Color(0xFF8AADF4);
  final String fallbackImage = "https://via.placeholder.com/100";

  @override
  void initState() {
    super.initState();
    books = apiService.fetchBooks();
  }

  void _navigateToEditPage(Map<String, dynamic> book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditionLivrePage(book: book)),
    );

    if (result == true) {
      setState(() {
        books = apiService.fetchBooks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Liste des livres"),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: books,
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data?.map((book) {
              return Card(
                color: cardColor,
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(book["image"] ?? fallbackImage, width: 50, height: 50),
                  title: Text(book["libelle"], style: TextStyle(color: textColor)),
                  onTap: () => _navigateToEditPage(book),
                ),
              );
            }).toList() ?? [],
          );
        },
      ),
    );
  }
}
