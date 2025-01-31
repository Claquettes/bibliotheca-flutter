import 'package:flutter/material.dart';
import '../database/dao.dart';

class EditionCategoriePage extends StatefulWidget {
  final Map<String, dynamic>? category;

  EditionCategoriePage({this.category});

  @override
  _EditionCategoriePageState createState() => _EditionCategoriePageState();
}

class _EditionCategoriePageState extends State<EditionCategoriePage> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _libelleController;

  final Color backgroundColor = Color(0xFF24273A);
  final Color cardColor = Color(0xFF363A4F);
  final Color textColor = Color(0xFFCAD3F5);
  final Color primaryColor = Color(0xFF8AADF4);

  @override
  void initState() {
    super.initState();
    _libelleController = TextEditingController(text: widget.category?["libelle"] ?? "");
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> categoryData = {
        "libelle": _libelleController.text,
      };

      if (widget.category == null) {
        apiService.createCategory(categoryData).then((_) => Navigator.pop(context, true));
      } else {
        apiService.updateCategory(widget.category!["id"], categoryData).then((_) {
          Navigator.pop(context, true);
        }).catchError((e) {
          print("Update failed: $e");
        });
      }
    }
  }

  @override
  void dispose() {
    _libelleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.category == null ? "Ajouter une catégorie" : "Modifier la catégorie"),
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
                  _buildTextField(_libelleController, "Nom de la catégorie"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: _saveCategory,
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
