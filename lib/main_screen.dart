import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmationDialog(context);
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (index) => _onItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat', // Changed from Uslub to Riwayat
            ),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(
              icon: Icon(Icons.style),
              label: 'Flashcards',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedItemColor: Colors.blueAccent, // Accent Blue
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    PanaraConfirmDialog.show(
      context,
      title: 'Tutup Aplikasi',
      message: 'Apakah Anda yakin ingin menutup aplikasi?',
      confirmButtonText: 'Ya, Tutup',
      cancelButtonText: 'Batal',
      onTapConfirm: () {
        Navigator.of(context).pop();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      onTapCancel: () {
        Navigator.of(context).pop();
      },
      panaraDialogType: PanaraDialogType.warning,
      barrierDismissible: false,
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.routerDelegate.currentConfiguration.uri
        .toString();
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
