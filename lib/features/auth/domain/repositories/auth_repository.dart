import 'package:mjumbe/core/error/failures.dart';
import 'package:mjumbe/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Stream pour écouter les changements d'état de la session
  Stream<UserEntity?> get userStream;

  /// Récupère l'utilisateur actuellement connecté
  UserEntity? get currentUser;

  /// Inscription avec Email & Mot de passe
  Future<({Failure? failure, UserEntity? user})> signUp({
    required String email,
    required String password,
  });

  /// Connexion avec Email & Mot de passe
  Future<({Failure? failure, UserEntity? user})> signIn({
    required String email,
    required String password,
  });

  /// Déconnexion
  Future<({Failure? failure, void data})> signOut();
}