import 'package:flutter/material.dart';
import 'package:mjumbe/app/theme/app_theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper_rounded,
              size: 72,
              color: AppTheme.primaryNeutral,
            ),
            SizedBox(height: 24),
            Text(
              'LUMA NEWS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: AppTheme.primaryNeutral,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'L\'actualité simplifiée',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryNeutral,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 64),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondaryNeutral),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
