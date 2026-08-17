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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  String? initError;

  try {
    // 1. Initialiser Firebase
    await Firebase.initializeApp();
    
    // 2. Charger le fichier .env
    await dotenv.load(fileName: ".env");
    
    // 3. Initialiser les dépendances (GetIt)
    await di.initDependencies();
  } catch (e, stackTrace) {
    debugPrint("Erreur critique lors de l'initialisation : $e");
    debugPrint(stackTrace.toString());
    initError = e.toString();
  }
  
  runApp(MyApp(error: initError));
}

class MyApp extends StatefulWidget {
  final String? error;
  const MyApp({super.key, this.error});

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
        BlocProvider<NewsBloc>(create: (_) => di.sl<NewsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Mjumbe App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.createRouter(_authBloc!),
      ),
    );
  }
}
