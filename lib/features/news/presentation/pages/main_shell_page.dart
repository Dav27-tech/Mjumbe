import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mjumbe/app/theme/app_theme.dart';

class MainShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellPage({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.borderLight, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
          backgroundColor: AppTheme.surfaceLight,
          elevation: 0,
          selectedItemColor: AppTheme.primaryNeutral,
          unselectedItemColor: AppTheme.secondaryNeutral,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined, size: 22),
              activeIcon: Icon(Icons.explore_rounded, size: 22),
              label: 'EXPLORER',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks_outlined, size: 22),
              activeIcon: Icon(Icons.bookmarks_rounded, size: 22),
              label: 'SIGNETS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, size: 22),
              activeIcon: Icon(Icons.account_circle_rounded, size: 22),
              label: 'PROFIL',
            ),
          ],
        ),
      ),
    );
  }
}
