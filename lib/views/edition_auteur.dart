import 'package:flutter/material.dart';
import '../database/dao.dart';
import '../models/auteur.dart';

class EditionAuteurPage extends StatefulWidget {
  final Auteur? author;

  EditionAuteurPage({this.author});

  @override
  _EditionAuteurPageState createState() => _EditionAuteurPageState();
}

class _EditionAuteurPageState extends State<EditionAuteurPage> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomsController;
  late TextEditingController _emailController;

  final Color backgroundColor = Color(0xFF24273A);
  final Color cardColor = Color(0xFF363A4F);
  final Color textColor = Color(0xFFCAD3F5);
  final Color primaryColor = Color(0xFF8AADF4);

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.author?.nom ?? "");
    _prenomsController = TextEditingController(text: widget.author?.prenoms ?? "");
    _emailController = TextEditingController(text: widget.author?.email ?? "");
  }

  void _saveAuthor() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> authorData = {
        "nom": _nomController.text,
        "prenoms": _prenomsController.text,
        "email": _emailController.text,
      };

      if (widget.author == null) {
        apiService.createAuthor(authorData).then((_) => Navigator.pop(context, true));
      } else {
        apiService.updateAuthor(widget.author!.id!, authorData).then((_) {
          Navigator.pop(context, true);
        }).catchError((e) {
          print("Update failed: $e");
        });
      }
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomsController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.author == null ? "Ajouter un auteur" : "Modifier l'auteur"),
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
                  _buildTextField(_nomController, "Nom"),
                  _buildTextField(_prenomsController, "Prénoms"),
                  _buildTextField(_emailController, "Email"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: _saveAuthor,
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
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
    );
  }
}
