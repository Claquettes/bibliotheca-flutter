import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/database_helper.dart';
import 'package:sqflite/sqflite.dart'; // ✅ Import sqflite for ConflictAlgorithm



class SyncService {
  final DatabaseHelper dbHelper = DatabaseHelper();
  static const String apiBaseUrl = "http://localhost:3000";

  // 🔄 Synchronisation : Récupérer les catégories depuis l'API et les stocker localement
  Future<void> syncCategoriesWithAPI() async {
    final db = await dbHelper.database;

    var url = Uri.parse('$apiBaseUrl/categories');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> categories = json.decode(response.body);

      for (var categorie in categories) {
        var existingCategory = await db.query(
          'categorie',
          where: 'id = ?',
          whereArgs: [categorie['id']],
        );

        String? localTimestamp = existingCategory.isNotEmpty ? existingCategory.first['last_updated'] as String? : null;
        String? remoteTimestamp = categorie['last_updated'] as String?;

        if (existingCategory.isEmpty) {
          // 📌 Insérer si la catégorie n'existe pas
          await db.insert('categorie', {
            'id': categorie['id'],
            'libelle': categorie['libelle'],
            'last_updated': remoteTimestamp ?? DateTime.now().toIso8601String(),
            'is_synced': 1,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        } else {
          // 📌 Vérifier le timestamp pour éviter les conflits
          if (remoteTimestamp != null && (localTimestamp == null || DateTime.parse(remoteTimestamp).isAfter(DateTime.parse(localTimestamp)))) {
            await db.update(
              'categorie',
              {
                'libelle': categorie['libelle'],
                'last_updated': remoteTimestamp,
                'is_synced': 1,
              },
              where: 'id = ?',
              whereArgs: [categorie['id']],
            );
          }
        }
      }
    } else {
      print('Erreur lors de la récupération des catégories');
    }
  }

  // 🔄 Synchronisation : Envoyer les catégories locales vers l'API
  Future<void> pushCategoriesToAPI() async {
    final db = await dbHelper.database;
    List<Map<String, dynamic>> categories = await db.query('categorie', where: 'is_synced = ?', whereArgs: [0]);

    for (var categorie in categories) {
      var url = Uri.parse('$apiBaseUrl/categories');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id': categorie['id'],
          'libelle': categorie['libelle'],
          'last_updated': categorie['last_updated'] != null ? categorie['last_updated'] : DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        await db.update('categorie', {'is_synced': 1}, where: 'id = ?', whereArgs: [categorie['id']]);
      }
    }
  }
}
