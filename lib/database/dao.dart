import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse("$baseUrl/livres"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load books");
    }
  }

  Future<List<dynamic>> fetchAuthors() async {
    final response = await http.get(Uri.parse("$baseUrl/auteurs"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load authors");
    }
  }

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load categories");
    }
  }

  Future<void> createBook(Map<String, dynamic> bookData) async {
    await http.post(Uri.parse("$baseUrl/livres"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookData));
  }

  Future<void> updateBook(int id, Map<String, dynamic> bookData) async {
    await http.put(Uri.parse("$baseUrl/livres/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookData));
  }

  Future<void> deleteBook(int id) async {
    await http.delete(Uri.parse("$baseUrl/livres/$id"));
  }
}
