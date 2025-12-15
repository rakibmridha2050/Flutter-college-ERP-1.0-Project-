import 'package:college_erp/provider/class_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FilterByDepartmentScreen extends StatefulWidget {
  const FilterByDepartmentScreen({super.key});

  @override
  State<FilterByDepartmentScreen> createState() => _FilterByDepartmentScreenState();
}

class _FilterByDepartmentScreenState extends State<FilterByDepartmentScreen> {
  final _departmentIdController = TextEditingController();
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    // Clear previous data when entering this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassProvider>().clearClasses();
    });
  }

  @override
  void dispose() {
    _departmentIdController.dispose();
    super.dispose();
  }

  Future<void> _filterClasses() async {
    if (_departmentIdController.text.isEmpty) return;

    setState(() => _hasSearched = true);
    final departmentId = int.tryParse(_departmentIdController.text);
    
    if (departmentId != null) {
      await context.read<ClassProvider>().fetchClassesByDepartment(departmentId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid department ID'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter by Department'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ClassProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search Input
                TextField(
                  controller: _departmentIdController,
                  decoration: InputDecoration(
                    labelText: 'Department ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _departmentIdController.clear();
                        provider.clearClasses();
                        setState(() => _hasSearched = false);
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _filterClasses(),
                ),
                const SizedBox(height: 16),

                // Search Button
                ElevatedButton.icon(
                  onPressed: provider.isLoading ? null : _filterClasses,
                  icon: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(provider.isLoading ? 'Searching...' : 'Search'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Results Section
                if (_hasSearched)
                  Expanded(
                    child: _buildResultsSection(context, provider),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsSection(BuildContext context, ClassProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'Error: ${provider.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _filterClasses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.class_, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              'No classes found for Department ID: ${_departmentIdController.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Results (${provider.classes.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => provider.fetchClassesByDepartment(
                  int.parse(_departmentIdController.text),
                ),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.classes.length,
            itemBuilder: (context, index) {
              final classItem = provider.classes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(Icons.class_, color: Colors.green),
                  ),
                  title: Text(classItem.className),
                  subtitle: Text('ID: ${classItem.id}'),
                  trailing: Text('Dept: ${classItem.departmentId}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}