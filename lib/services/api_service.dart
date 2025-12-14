import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/department.dart';
import '../utils/constants.dart';

class ApiService {
  final String baseUrl = 'https://college-final-project-backend.onrender.com';
  
  Future<List<Department>> getDepartments() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/departments'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  Future<Department> getDepartment(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/departments/$id'));
      
      if (response.statusCode == 200) {
        return Department.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load department');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  Future<Department> createDepartment(Department department) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/departments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(department.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Department.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create department');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  Future<Department> updateDepartment(int id, Department department) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/departments/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(department.toJson()),
      );
      
      if (response.statusCode == 200) {
        return Department.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update department');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  Future<bool> deleteDepartment(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/departments/$id'),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}