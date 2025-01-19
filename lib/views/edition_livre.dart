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
  late TextEditingController _nbPagesController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?["libelle"] ?? "");
    _descriptionController = TextEditingController(text: widget.book?["description"] ?? "");
    _nbPagesController = TextEditingController(text: widget.book?["nbPage"]?.toString() ?? "");
    _imageController = TextEditingController(text: widget.book?["image"] ?? "");
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> bookData = {
        "libelle": _titleController.text,
        "description": _descriptionController.text,
        "nbPage": int.tryParse(_nbPagesController.text) ?? 0,
        "image": _imageController.text,
      };

      if (widget.book == null) {
        apiService.createBook(bookData).then((_) => Navigator.pop(context, true));
      } else {
        apiService.updateBook(widget.book!["id"], bookData).then((_) => Navigator.pop(context, true));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _nbPagesController.dispose();
    _imageController.dispose();
    super.dispose();
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
              TextFormField(
                controller: _nbPagesController,
                decoration: InputDecoration(labelText: "Nombre de pages"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Le nombre de pages est requis" : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: "URL de l'image"),
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
