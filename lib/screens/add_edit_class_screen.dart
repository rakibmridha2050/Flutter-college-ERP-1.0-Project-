import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/class_model.dart';
import '../provider/class_provider.dart';

class AddEditClassScreen extends StatefulWidget {
  final ClassModel? classModel;

  const AddEditClassScreen({super.key, this.classModel});

  @override
  State<AddEditClassScreen> createState() => _AddEditClassScreenState();
}

class _AddEditClassScreenState extends State<AddEditClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _departmentIdController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Move provider calls to post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassProvider>().clearError();
    });

    if (widget.classModel != null) {
      _classNameController.text = widget.classModel!.className;
      _departmentIdController.text = widget.classModel!.departmentId.toString();
    }
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _departmentIdController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final departmentId = int.tryParse(_departmentIdController.text.trim());
    if (departmentId == null || departmentId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid department ID')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final provider = context.read<ClassProvider>();
    final isEditing = widget.classModel != null;

    final classModel = ClassModel(
      id: widget.classModel?.id,
      className: _classNameController.text.trim(),
      departmentId: departmentId,
    );

    final success = isEditing
        ? await provider.updateClassItem(widget.classModel!.id!, classModel)
        : await provider.addClass(classModel);

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Class updated successfully!' : 'Class created successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted && provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${provider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.classModel != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Class' : 'Add New Class'),
        actions: [
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Class Name
              TextFormField(
                controller: _classNameController,
                decoration: InputDecoration(
                  labelText: 'Class Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.class_),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter class name';
                  if (value.length < 2) return 'Class name must be at least 2 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Department ID
              TextFormField(
                controller: _departmentIdController,
                decoration: InputDecoration(
                  labelText: 'Department ID',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.numbers),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter department ID';
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Please enter a valid positive number';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : () => _submitForm(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(isEditing ? 'Update Class' : 'Create Class', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
