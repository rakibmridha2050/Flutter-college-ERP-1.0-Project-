import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/class_model.dart';
import '../provider/class_provider.dart';
import 'add_edit_class_screen.dart';

class ClassDetailScreen extends StatefulWidget {
  final int classId;

  const ClassDetailScreen({super.key, required this.classId});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  ClassModel? _classModel;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Schedule fetch after the first frame to avoid build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchClassDetails();
    });
  }

  Future<void> _fetchClassDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final provider = context.read<ClassProvider>();
      final classItem = await provider.fetchClassById(widget.classId);

      if (classItem != null) {
        if (mounted) setState(() => _classModel = classItem);
      } else {
        if (mounted) setState(() => _error = 'Class not found');
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchClassDetails,
          ),
          if (_classModel != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEditClassScreen(classModel: _classModel),
                  ),
                ).then((value) {
                  if (value == true) _fetchClassDetails();
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_error'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchClassDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _classModel == null
                  ? const Center(child: Text('Class not found'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.class_,
                                    size: 40, color: Colors.blue),
                                title: Text(
                                  _classModel!.className,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('Class ID: ${_classModel!.id}'),
                              ),
                              const Divider(),
                              _buildDetailItem(
                                  'Department ID',
                                  _classModel!.departmentId.toString()),
                              const SizedBox(height: 30),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showDeleteDialog(context, _classModel!);
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete Class'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ClassModel classModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
            'Are you sure you want to delete "${classModel.className}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<ClassProvider>();
              final success = await provider.deleteClassItem(classModel.id!);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Class deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // Go back after delete
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Failed to delete class: ${provider.error ?? "Unknown error"}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
