import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:word_game/core/services/auth_service.dart';

class AuthState extends Equatable {
  const AuthState({
    this.isSignedIn = false,
    this.displayName = 'Player',
    this.email,
    this.userId,
    this.photoUrl,
    this.isGoogleSignIn = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isSignedIn;
  final String displayName;
  final String? email;
  final String? userId;
  final String? photoUrl;
  final bool isGoogleSignIn;
  final bool isLoading;
  final String? errorMessage;

  AuthState copyWith({
    bool? isSignedIn,
    String? displayName,
    String? email,
    String? userId,
    String? photoUrl,
    bool? isGoogleSignIn,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      photoUrl: photoUrl ?? this.photoUrl,
      isGoogleSignIn: isGoogleSignIn ?? this.isGoogleSignIn,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        isSignedIn,
        displayName,
        email,
        userId,
        photoUrl,
        isGoogleSignIn,
        isLoading,
        errorMessage,
      ];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._auth) : super(const AuthState()) {
    _subscription = _auth.authStateChanges.listen(_onAuthChanged);
    _onAuthChanged(_auth.currentUser);
  }

  final AuthService _auth;
  StreamSubscription<User?>? _subscription;

  void _onAuthChanged(User? user) {
    final wasSignedIn = state.isSignedIn;
    emit(
      state.copyWith(
        isSignedIn: user != null,
        userId: user?.uid,
        email: user?.email,
        displayName: _auth.displayName,
        photoUrl: _auth.photoUrl,
        isGoogleSignIn: _auth.isGoogleSignIn,
        isLoading: false,
        clearError: true,
      ),
    );

    if (user != null && !wasSignedIn) {
      unawaited(_syncUserData());
    }
  }

  Future<void> _syncUserData() async {
    try {
      await _auth.syncSignedInUserData();
    } catch (e, st) {
      debugPrint('Cloud sync on login failed: $e\n$st');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _auth.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: _auth.readableAuthError(e),
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _auth.signInWithEmail(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: _auth.readableAuthError(e),
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _auth.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'google-cancelled') {
        emit(state.copyWith(isLoading: false, clearError: true));
        return;
      }
      emit(state.copyWith(
        isLoading: false,
        errorMessage: _auth.readableAuthError(e),
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> updateDisplayName(String name) async {
    final warning = await _auth.updateDisplayName(name);
    emit(
      state.copyWith(
        displayName: _auth.displayName,
        photoUrl: _auth.photoUrl,
        isGoogleSignIn: _auth.isGoogleSignIn,
        clearError: warning == null,
        errorMessage: warning,
      ),
    );
    return warning;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
