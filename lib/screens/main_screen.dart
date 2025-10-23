import 'package:flutter/material.dart';
import 'package:taleb/screens/library_screen.dart';
import 'package:taleb/screens/study_plans_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // لتعقب التبويب الحالي

  static final List<Widget> _widgetOptions = <Widget>[
    const LibraryScreen(), // شاشة المكتبة (الكتب والمصنفات)
    const StudyPlansScreen(), // شاشة الخطط الدراسية
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لا نحتاج AppBar هنا، سيكون داخل كل شاشة فرعية
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'المكتبة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'الخطط الدراسية',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}
