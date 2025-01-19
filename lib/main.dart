import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() {
  runApp(MaterialApp(
    title: "Bibliotheca",
    theme: ThemeData(primaryColor: Colors.blue),
    home: HomePage(),
  ));
}