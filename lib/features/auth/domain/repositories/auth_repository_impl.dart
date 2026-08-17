import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mjumbe/core/error/failures.dart';
import 'package:mjumbe/features/auth/domain/entities/user_entity.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({required this.firebaseAuth});

  UserEntity? _mapFirebaseUser(User? user) {
    if (user == null) return null;
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<UserEntity?> get userStream {
    return firebaseAuth.authStateChanges().map(_mapFirebaseUser);
  }

  @override
  UserEntity? get currentUser => _mapFirebaseUser(firebaseAuth.currentUser);

  @override
  Future<({Failure? failure, UserEntity? user})> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (failure: null, user: _mapFirebaseUser(credential.user));
    } on FirebaseAuthException catch (e) {
      return (failure: AuthFailure(_mapFirebaseErrorMessage(e.code)), user: null);
    } catch (e) {
      return (failure: AuthFailure(e.toString()), user: null);
    }
  }

  @override
  Future<({Failure? failure, UserEntity? user})> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (failure: null, user: _mapFirebaseUser(credential.user));
    } on FirebaseAuthException catch (e) {
      return (failure: AuthFailure(_mapFirebaseErrorMessage(e.code)), user: null);
    } catch (e) {
      return (failure: AuthFailure(e.toString()), user: null);
    }
  }

  @override
  Future<({Failure? failure, void data})> signOut() async {
    try {
      await firebaseAuth.signOut();
      return (failure: null, data: null);
    } catch (e) {
      return (failure: AuthFailure(e.toString()), data: null);
    }
  }

  @override
  Future<String?> getOAuth2AccessToken({bool forceRefresh = false}) async {
    try {
      // Firebase gère le cycle de vie OAuth2 / JWT de manière sécurisée
      return await firebaseAuth.currentUser?.getIdToken(forceRefresh);
    } catch (e) {
      debugPrint("Erreur lors de la récupération du token OAuth2: $e");
      return null;
    }
  }

  String _mapFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet e-mail.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet e-mail.';
      case 'invalid-email':
        return 'Adresse e-mail invalide.';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères.';
      case 'operation-not-allowed':
        return 'L\'authentification par e-mail n\'est pas activée dans la console Firebase.';
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard.';
      case 'configuration-not-found':
        return 'Erreur de configuration Firebase (CONFIGURATION_NOT_FOUND). Vérifiez l\'activation des services et les clés SHA.';
      default:
        return 'Erreur d\'authentification ($code).';
    }
  }
}
