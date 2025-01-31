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

  final Color backgroundColor = Color(0xFF24273A);
  final Color cardColor = Color(0xFF363A4F);
  final Color textColor = Color(0xFFCAD3F5);
  final Color primaryColor = Color(0xFF8AADF4);

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
        apiService.updateBook(widget.book!["id"], bookData).then((_) {
          Navigator.pop(context, true);
        }).catchError((e) {
          print("Update failed: $e");
        });
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.book == null ? "Ajouter un livre" : "Modifier le livre"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_titleController, "Titre"),
                  _buildTextField(_descriptionController, "Description"),
                  _buildTextField(_nbPagesController, "Nombre de pages", isNumeric: true),
                  _buildTextField(_imageController, "URL de l'image"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: _saveBook,
                    child: Text("Enregistrer", style: TextStyle(color: textColor)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor),
          filled: true,
          fillColor: Color(0xFF2E3350),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value!.isEmpty ? "$label est requis" : null,
      ),
    );
  }
}
