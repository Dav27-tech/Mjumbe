import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/app/router/app_router.dart';
import 'package:mjumbe/app/theme/app_theme.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_event.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';
import 'package:mjumbe/injection_container.dart' as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/core/utils/connectivity_cubit.dart';
import 'package:mjumbe/core/widgets/offline_banner.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  String? initError;
  String? initStackTrace;

  try {
    // 1. Charger le fichier .env (doit être disponible avant l'initialisation Firebase sur le web)
    await dotenv.load(fileName: ".env");

    // 2. Initialiser Firebase
    if (kIsWeb) {
      // For web, FirebaseOptions must be provided. Prefer loading from .env.
      final apiKey = dotenv.env['FIREBASE_API_KEY'];
      final appId = dotenv.env['FIREBASE_APP_ID'];
      final messagingSenderId = dotenv.env['FIREBASE_MESSAGING_SENDER_ID'];
      final projectId = dotenv.env['FIREBASE_PROJECT_ID'];
      final authDomain = dotenv.env['FIREBASE_AUTH_DOMAIN'];
      final storageBucket = dotenv.env['FIREBASE_STORAGE_BUCKET'];
      final measurementId = dotenv.env['FIREBASE_MEASUREMENT_ID'];

      if (apiKey == null || apiKey.isEmpty || appId == null || appId.isEmpty || messagingSenderId == null || messagingSenderId.isEmpty || projectId == null || projectId.isEmpty) {
        throw Exception('Firebase Web configuration missing. Ensure FIREBASE_API_KEY, FIREBASE_APP_ID, FIREBASE_MESSAGING_SENDER_ID and FIREBASE_PROJECT_ID are set in .env for web.');
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
    debugPrint(stackTrace.toString());
    initError = e.toString();
    initStackTrace = stackTrace.toString();
  }
  
  runApp(MyApp(error: initError));
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si une erreur d'initialisation est survenue, on affiche un écran d'erreur au lieu de l'app
    if (widget.error != null || _authBloc == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    "Erreur de démarrage",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.error ?? "Le service d'authentification n'a pas pu être initialisé.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  if (widget.stackTrace != null)
                    _ErrorDetails(stackTrace: widget.stackTrace!),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => main(),
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc!),
        BlocProvider<ConnectivityCubit>(
          create: (_) => ConnectivityCubit(kIsWeb ? null : di.sl<InternetConnectionChecker>()),
        ),
        BlocProvider<NewsBloc>(create: (_) => di.sl<NewsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Mjumbe App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: di.sl<AppRouter>().router,
        builder: (context, child) => OfflineBanner(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}

class _ErrorDetails extends StatefulWidget {
  final String stackTrace;
  const _ErrorDetails({required this.stackTrace});

  @override
  State<_ErrorDetails> createState() => _ErrorDetailsState();
}

class _ErrorDetailsState extends State<_ErrorDetails> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Masquer les détails' : 'Afficher les détails'),
        ),
        if (_expanded)
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: SelectableText(widget.stackTrace, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ),
          ),
      ],
    );
  }
}
