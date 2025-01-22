import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'services/sync_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SyncManager.startAutoSync(); // l'auto synchro wow

  runApp(MaterialApp(
    title: "Bibliotheca",
    theme: ThemeData(primaryColor: Colors.blue),
    home: HomePage(),
  ));
}
