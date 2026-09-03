import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mjumbe/app/router/app_router.dart';
import 'package:mjumbe/l10n/app_localizations.dart';
import 'package:mjumbe/app/theme/app_theme.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_event.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';
import 'package:mjumbe/injection_container.dart' as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mjumbe/core/utils/connectivity_cubit.dart';
import 'package:mjumbe/core/widgets/offline_banner.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;
  String? initStackTrace;

  try {
    // 1. Charger le fichier .env
    await dotenv.load(fileName: ".env");

    // 2. Initialiser Firebase
    if (kIsWeb) {
      final apiKey = dotenv.env['FIREBASE_API_KEY'];
      final appId = dotenv.env['FIREBASE_APP_ID'];
      final messagingSenderId = dotenv.env['FIREBASE_MESSAGING_SENDER_ID'];
      final projectId = dotenv.env['FIREBASE_PROJECT_ID'];
      final authDomain = dotenv.env['FIREBASE_AUTH_DOMAIN'];
      final storageBucket = dotenv.env['FIREBASE_STORAGE_BUCKET'];
      final measurementId = dotenv.env['FIREBASE_MEASUREMENT_ID'];

      if (apiKey == null || appId == null || messagingSenderId == null || projectId == null) {
        throw Exception('Configuration Firebase Web manquante dans le fichier .env');
      }

      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
          authDomain: authDomain,
          storageBucket: storageBucket,
          measurementId: measurementId,
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    // 3. Initialiser les dépendances (GetIt)
    await di.initDependencies();
  } catch (e, stackTrace) {
    debugPrint("Erreur critique lors de l'initialisation : $e");
    initError = e.toString();
    initStackTrace = stackTrace.toString();
  }

  runApp(MyApp(error: initError, stackTrace: initStackTrace));
}

class AppLocaleScope extends InheritedWidget {
  final ValueNotifier<Locale> localeNotifier;

  const AppLocaleScope({
    required this.localeNotifier,
    required super.child,
  });

  static Locale of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    return scope?.localeNotifier.value ?? const Locale('fr');
  }

  static void setLocale(BuildContext context, Locale locale) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    if (scope != null) {
      scope.localeNotifier.value = locale;
    }
  }

  @override
  bool updateShouldNotify(AppLocaleScope oldWidget) =>
      localeNotifier != oldWidget.localeNotifier;
}

class MyApp extends StatefulWidget {
  final String? error;
  final String? stackTrace;
  const MyApp({super.key, this.error, this.stackTrace});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthBloc? _authBloc;
  final ValueNotifier<Locale> _localeController = ValueNotifier(const Locale('fr'));

  @override
  void initState() {
    super.initState();
    if (widget.error == null) {
      try {
        _authBloc = di.sl<AuthBloc>()..add(AuthCheckRequestedEvent());
      } catch (e) {
        debugPrint("Erreur GetIt dans initState : $e");
      }
    }
  }

  @override
  void dispose() {
    _authBloc?.close();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error != null || _authBloc == null) {
      return AppLocaleScope(
        localeNotifier: _localeController,
        child: ValueListenableBuilder<Locale>(
          valueListenable: _localeController,
          builder: (context, locale, _) {
            final l10n = AppLocalizations.of(context)!;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          l10n.errorStartup,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryNeutral),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.error ?? "Le service d'authentification n'a pas pu être initialisé.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.secondaryNeutral),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => main(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryNeutral,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(l10n.retryStartup),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return AppLocaleScope(
      localeNotifier: _localeController,
      child: ValueListenableBuilder<Locale>(
        valueListenable: _localeController,
        builder: (context, locale, _) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(value: _authBloc!),
              BlocProvider<ConnectivityCubit>(
                create: (_) => ConnectivityCubit(kIsWeb ? null : di.sl<InternetConnectionChecker>()),
              ),
              BlocProvider<NewsBloc>(create: (_) => di.sl<NewsBloc>()),
            ],
            child: MaterialApp.router(
              title: 'LUMA NEWS',
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: di.sl<AppRouter>().router,
              builder: (context, child) => OfflineBanner(child: child ?? const SizedBox.shrink()),
            ),
          );
        },
      ),
    );
  }
}
