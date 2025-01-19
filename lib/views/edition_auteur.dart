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
      appBar: AppBar(title: Text(widget.author == null ? "Ajouter un auteur" : "Modifier l'auteur")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: "Nom"),
                validator: (value) => value!.isEmpty ? "Le nom est requis" : null,
              ),
              TextFormField(
                controller: _prenomsController,
                decoration: InputDecoration(labelText: "Prénoms"),
                validator: (value) => value!.isEmpty ? "Le prénom est requis" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAuthor,
                child: Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
