import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/features/auth/domain/entities/user_entity.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_event.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  StreamSubscription<UserEntity?>? _userSubscription;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequestedEvent>(_onAuthCheckRequested);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthStatusChangedEvent>(_onAuthStatusChanged);

    // Écoute de la session Firebase en temps réel
    _userSubscription = authRepository.userStream.listen((user) {
      add(AuthStatusChangedEvent(user));
    });
  }

  void _onAuthStatusChanged(
    AuthStatusChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthenticatedState(event.user!));
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequestedEvent event,
      Emitter<AuthState> emit,
      ) async {
    final user = authRepository.currentUser;
    if (user != null) {
      emit(AuthenticatedState(user));
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onSignIn(
      AuthSignInEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await authRepository.signIn(
      email: event.email,
      password: event.password,
    );

    if (result.failure != null) {
      emit(AuthFailureState(result.failure!.message));
    }
  }

  Future<void> _onSignUp(
      AuthSignUpEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await authRepository.signUp(
      email: event.email,
      password: event.password,
    );

    if (result.failure != null) {
      emit(AuthFailureState(result.failure!.message));
    }
  }

  Future<void> _onSignOut(
      AuthSignOutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await authRepository.signOut();

    if (result.failure != null) {
      emit(AuthFailureState(result.failure!.message));
    } else {
      // Ensure UI reflects logged out state immediately
      emit(UnauthenticatedState());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}