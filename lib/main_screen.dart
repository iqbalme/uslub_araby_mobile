
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Uslub', // New Uslub Screen
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            label: 'Flashcards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.routerDelegate.currentConfiguration.uri.toString();
    if (location.startsWith('/uslub')) {
      return 1;
    }
    if (location.startsWith('/saved')) {
      return 2;
    }
    if (location.startsWith('/flashcards')) {
      return 3;
    }
    if (location.startsWith('/profile')) {
      return 4;
    }
    return 0; // Home is the default
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/uslub'); // Navigate to Uslub
        break;
      case 2:
        GoRouter.of(context).go('/saved');
        break;
      case 3:
        GoRouter.of(context).go('/flashcards');
        break;
      case 4:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
}
