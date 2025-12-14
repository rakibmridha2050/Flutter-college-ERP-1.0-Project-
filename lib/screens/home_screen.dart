import 'package:flutter/material.dart';
import 'department_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Manager'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_rounded,
              size: 100,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Department Manager',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Manage your departments efficiently',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DepartmentListScreen(),
            ),
          );
        },
        icon: const Icon(Icons.list),
        label: const Text('View Departments'),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}