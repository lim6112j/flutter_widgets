import 'package:flutter/material.dart';
import 'package:navigation_routing_app/pages/setting_page.dart';
import 'package:navigation_routing_app/pages/user_page.dart';

class DefaultTabController extends StatefulWidget {
  const DefaultTabController({super.key, required this.child});

  final Widget child;

  @override
  State<DefaultTabController> createState() => _DefaultTabControllerState();
}

class _DefaultTabControllerState extends State<DefaultTabController> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SettingPage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
