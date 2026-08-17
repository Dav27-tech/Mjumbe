import 'package:equatable/equatable.dart';
import 'package:mjumbe/features/auth/domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequestedEvent extends AuthEvent {}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutEvent extends AuthEvent {}

class AuthStatusChangedEvent extends AuthEvent {
  final UserEntity? user;

  const AuthStatusChangedEvent(this.user);

  @override
  List<Object?> get props => [user];
}