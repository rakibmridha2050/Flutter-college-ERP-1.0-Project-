import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/class_model.dart';

class ClassApiService {
  static final String baseUrl = 'https://college-final-project-backend.onrender.com';

  // 🔹 Fetch all classes
  static Future<List<ClassModel>> getClasses() async {
    try {
      final url = Uri.parse('$baseUrl/api/classes');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ClassModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch classes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 🔹 Fetch single class by ID
  static Future<ClassModel> getClassById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/api/classes/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return ClassModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Class not found');
      } else {
        throw Exception('Failed to fetch class: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 🔹 Fetch classes by department
  static Future<List<ClassModel>> getClassesByDepartment(int departmentId) async {
    try {
      final url = Uri.parse('$baseUrl/api/classes/department/$departmentId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ClassModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch classes by department: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 🔹 Create new class
  static Future<ClassModel> createClass(ClassModel newClass) async {
      print(newClass.departmentId);
    try {
      final url = Uri.parse('$baseUrl/api/classes');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newClass.toJson()),
      );
print(response.body);


      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClassModel.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception('Failed to create class: ${error['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 🔹 Update class
  static Future<ClassModel> updateClass(int id, ClassModel updatedClass) async {
    try {
      final url = Uri.parse('$baseUrl/api/classes/$id');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedClass.toJson()),
      );

      if (response.statusCode == 200) {
        return ClassModel.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception('Failed to update class: ${error['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 🔹 Delete class
  static Future<void> deleteClass(int id) async {
    try {
      final url = Uri.parse('$baseUrl/api/classes/$id');
      final response = await http.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        final error = jsonDecode(response.body);
        throw Exception('Failed to delete class: ${error['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}