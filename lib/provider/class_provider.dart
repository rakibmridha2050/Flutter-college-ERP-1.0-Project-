import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../services/class_api_service.dart';

class ClassProvider with ChangeNotifier {
  List<ClassModel> _classes = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ClassModel> get classes => _classes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 🔹 Clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // 🔹 Clear classes list
  void clearClasses() {
    _classes = [];
    notifyListeners();
  }

  // 🔹 Fetch all classes
  Future<bool> fetchClasses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _classes = await ClassApiService.getClasses();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Fetch classes by department
  Future<bool> fetchClassesByDepartment(int departmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _classes = await ClassApiService.getClassesByDepartment(departmentId);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Fetch class by ID
  Future<ClassModel?> fetchClassById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final classItem = await ClassApiService.getClassById(id);
      return classItem;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Add new class
  Future<bool> addClass(ClassModel newClass) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final createdClass = await ClassApiService.createClass(newClass);
      _classes.add(createdClass);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Update class
  Future<bool> updateClassItem(int id, ClassModel updatedClass) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ClassApiService.updateClass(id, updatedClass);
      final index = _classes.indexWhere((c) => c.id == id);
      if (index != -1) _classes[index] = result;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Delete class
  Future<bool> deleteClassItem(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ClassApiService.deleteClass(id);
      _classes.removeWhere((c) => c.id == id);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
