import 'package:flutter/material.dart';
import 'package:white_border/features/home/ui/home_screen.dart';
import 'package:white_border/features/settings/ui/settings_screen.dart';
import 'package:white_border/features/export/ui/export_screen.dart';
class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedTab = 0;

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  List _pages = [

HomeScreen(),
SettingsScreen(),
ExportScreen(),
];  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          _changeTab(index);
        },
        items: const [
BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
BottomNavigationBarItem(icon: Icon(Icons.home), label: 'settings'),
BottomNavigationBarItem(icon: Icon(Icons.home), label: 'export'),
        ],
      ),
    );
  }
}
