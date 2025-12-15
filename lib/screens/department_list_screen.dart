import 'package:flutter/material.dart';

import '../models/department.dart';
import '../services/api_service.dart';
import 'add_edit_department_screen.dart';
import 'department_detail_screen.dart';
import '../widgets/department_card.dart';

class DepartmentListScreen extends StatefulWidget {
  const DepartmentListScreen({super.key});

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  late Future<List<Department>> _departmentsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _departmentsFuture = _apiService.getDepartments();
  }

  void _refreshDepartments() {
    setState(() {
      _departmentsFuture = _apiService.getDepartments();
    });
  }

  void _showDeleteDialog(int departmentId, String departmentName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Department'),
        content: Text('Are you sure you want to delete "$departmentName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteDepartment(departmentId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDepartment(int id) async {
    try {
      await _apiService.deleteDepartment(id);
      _refreshDepartments();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Department deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting department: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDepartments,
          ),
        ],
      ),
      body: FutureBuilder<List<Department>>(
        future: _departmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshDepartments,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.business_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No departments found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditDepartmentScreen(
                            onDepartmentSaved: _refreshDepartments,
                          ),
                        ),
                      );
                    },
                    child: const Text('Add First Department'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final department = snapshot.data![index];
              return DepartmentCard(
                department: department,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DepartmentDetailScreen(
                        departmentId: department.deptId!,
                      ),
                    ),
                  );
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditDepartmentScreen(
                        department: department,
                        onDepartmentSaved: _refreshDepartments,
                      ),
                    ),
                  );
                },
                onDelete: () {
                  _showDeleteDialog(department.deptId!, department.deptName);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditDepartmentScreen(
                onDepartmentSaved: _refreshDepartments,
              ),
            ),
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }
}