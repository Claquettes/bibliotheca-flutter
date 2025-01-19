import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/auteur.dart'; // Ensure correct import path


class ApiService {
  static const String baseUrl = "http://localhost:3000";

  // 📚 FETCH BOOKS
  Future<List<dynamic>> fetchBooks() async {
    try {
      print("Fetching books from API...");
      final response = await http.get(Uri.parse("$baseUrl/livres"));
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load books: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchBooks: $e");
      throw Exception("Error loading books: $e");
    }
  }

  // 📚 CREATE BOOK
  Future<void> createBook(Map<String, dynamic> bookData) async {
    try {
      print("Creating book: $bookData");
      final response = await http.post(
        Uri.parse("$baseUrl/livres"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookData),
      );

      print("Create Response Status: ${response.statusCode}");
      if (response.statusCode != 201) {
        throw Exception("Failed to create book: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in createBook: $e");
      throw Exception("Error creating book: $e");
    }
  }

  // 📚 UPDATE BOOK
  Future<void> updateBook(int id, Map<String, dynamic> bookData) async {
    try {
      print("Updating book ID $id with data: $bookData");
      final response = await http.put(
        Uri.parse("$baseUrl/livres/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookData),
      );

      print("Update Response Status: ${response.statusCode}");
      if (response.statusCode != 200) {
        throw Exception("Failed to update book: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in updateBook: $e");
      throw Exception("Error updating book: $e");
    }
  }

  // 📚 DELETE BOOK
  Future<void> deleteBook(int id) async {
    try {
      print("Deleting book ID: $id");
      final response = await http.delete(Uri.parse("$baseUrl/livres/$id"));

      print("Delete Response Status: ${response.statusCode}");
      if (response.statusCode != 200) {
        throw Exception("Failed to delete book: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in deleteBook: $e");
      throw Exception("Error deleting book: $e");
    }
  }

  // 👤 FETCH AUTHORS
  Future<List<Auteur>> fetchAuthors() async {
    try {
      print("Fetching authors...");
      final response = await http.get(Uri.parse("$baseUrl/auteurs"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Auteur.fromJson(json)).toList(); // Convert API data to `Auteur` list
      } else {
        throw Exception("Failed to load authors: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchAuthors: $e");
      throw Exception("Error loading authors: $e");
    }
  }


  // 👤 CREATE AUTHOR
  Future<void> createAuthor(Map<String, dynamic> authorData) async {
    try {
      print("Creating author: $authorData");
      final response = await http.post(
        Uri.parse("$baseUrl/auteurs"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(authorData),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create author: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in createAuthor: $e");
      throw Exception("Error creating author: $e");
    }
  }

  // 👤 UPDATE AUTHOR
  Future<void> updateAuthor(int id, Map<String, dynamic> authorData) async {
    try {
      print("Updating author ID $id with data: $authorData");
      final response = await http.put(
        Uri.parse("$baseUrl/auteurs/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(authorData),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update author: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in updateAuthor: $e");
      throw Exception("Error updating author: $e");
    }
  }

  // 👤 DELETE AUTHOR
  Future<void> deleteAuthor(int id) async {
    try {
      print("Deleting author ID: $id");
      final response = await http.delete(Uri.parse("$baseUrl/auteurs/$id"));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete author: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in deleteAuthor: $e");
      throw Exception("Error deleting author: $e");
    }
  }

  // 🏷️ FETCH CATEGORIES
  Future<List<dynamic>> fetchCategories() async {
    try {
      print("Fetching categories...");
      final response = await http.get(Uri.parse("$baseUrl/categories"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchCategories: $e");
      throw Exception("Error loading categories: $e");
    }
  }

  // 🏷️ CREATE CATEGORY
  Future<void> createCategory(Map<String, dynamic> categoryData) async {
    try {
      print("Creating category: $categoryData");
      final response = await http.post(
        Uri.parse("$baseUrl/categories"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(categoryData),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create category: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in createCategory: $e");
      throw Exception("Error creating category: $e");
    }
  }

  // 🏷️ UPDATE CATEGORY
  Future<void> updateCategory(int id, Map<String, dynamic> categoryData) async {
    try {
      print("Updating category ID $id with data: $categoryData");
      final response = await http.put(
        Uri.parse("$baseUrl/categories/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(categoryData),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update category: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in updateCategory: $e");
      throw Exception("Error updating category: $e");
    }
  }

  // 🏷️ DELETE CATEGORY
  Future<void> deleteCategory(int id) async {
    try {
      print("Deleting category ID: $id");
      final response = await http.delete(Uri.parse("$baseUrl/categories/$id"));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete category: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in deleteCategory: $e");
      throw Exception("Error deleting category: $e");
    }
  }
}
