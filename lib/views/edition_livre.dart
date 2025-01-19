import 'package:flutter/material.dart';
import '../database/dao.dart';

class EditionLivrePage extends StatefulWidget {
  final Map<String, dynamic>? book;

  EditionLivrePage({this.book});

  @override
  _EditionLivrePageState createState() => _EditionLivrePageState();
}

class _EditionLivrePageState extends State<EditionLivrePage> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?["libelle"] ?? "");
    _descriptionController = TextEditingController(text: widget.book?["description"] ?? "");
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> bookData = {
        "libelle": _titleController.text,
        "description": _descriptionController.text,
      };
      if (widget.book == null) {
        apiService.createBook(bookData).then((_) => Navigator.pop(context));
      } else {
        apiService.updateBook(widget.book!["id"], bookData).then((_) => Navigator.pop(context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book == null ? "Ajouter un livre" : "Modifier le livre")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Titre"),
                validator: (value) => value!.isEmpty ? "Le titre est requis" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBook,
                child: Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
