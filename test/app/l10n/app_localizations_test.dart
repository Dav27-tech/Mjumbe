import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mjumbe/l10n/app_localizations.dart';

void main() {
  testWidgets('French locale uses French strings', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => Scaffold(
            body: Text(AppLocalizations.of(context)!.loginTitle),
          ),
        ),
      ),
    );

    expect(find.text('Connexion'), findsOneWidget);
  });

  testWidgets('English locale uses English strings', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => Scaffold(
            body: Text(AppLocalizations.of(context)!.loginTitle),
          ),
        ),
      ),
    );

    expect(find.text('Sign in'), findsOneWidget);
  });
}
