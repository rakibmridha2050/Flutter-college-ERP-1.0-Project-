import 'package:flutter/material.dart';
import 'package:college_erp/screens/classes_list_screen.dart';
import 'package:college_erp/screens/home_content.dart';
import 'department_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeContent(),
    DepartmentListScreen(),
    ClassesListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Manager'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),

      // 🔹 Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.business, size: 48, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Department Manager',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.apartment),
              title: const Text('Departments'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('Classes'),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // 🔹 Body
      body: _screens[_currentIndex],

      // 🔹 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueGrey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Departments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classes',
          ),
        ],
      ),

      // 🔹 Floating Action Button
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: Colors.blueGrey,
              icon: const Icon(Icons.list),
              label: const Text('View Departments'),
              onPressed: () {
                setState(() => _currentIndex = 1);
              },
            )
          : null,
    );
  }
}
