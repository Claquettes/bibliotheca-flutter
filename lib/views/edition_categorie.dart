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
        print("Updating category with ID ${widget.category!["id"]}");
        print("Updated data: $categoryData");
        apiService.updateCategory(widget.category!["id"], categoryData).then((_) {
          print("Update successful!");
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
      appBar: AppBar(title: Text(widget.category == null ? "Ajouter une catégorie" : "Modifier la catégorie")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _libelleController,
                decoration: InputDecoration(labelText: "Nom de la catégorie"),
                validator: (value) => value!.isEmpty ? "Le nom de la catégorie est requis" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCategory,
                child: Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
