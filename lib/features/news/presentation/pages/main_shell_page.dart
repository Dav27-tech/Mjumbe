import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.65),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _onTap,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: Colors.white54,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined),
                  activeIcon: Icon(Icons.newspaper_rounded),
                  label: 'Actualités',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_outline_rounded),
                  activeIcon: Icon(Icons.bookmark_rounded),
                  label: 'Signets',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}