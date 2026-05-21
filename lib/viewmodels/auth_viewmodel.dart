import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user_model.dart';
import '../services/auth/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final UserModel? userModel;
  final bool isAuthenticated;
  final bool isInitialized;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.userModel,
    this.isAuthenticated = false,
    this.isInitialized = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserModel? userModel,
    bool? isAuthenticated,
    bool? isInitialized,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Overwrite error with new value
      userModel: userModel ?? this.userModel,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  StreamSubscription<supabase.AuthState>? _authSubscription;

  AuthNotifier(this._authService) : super(AuthState()) {
    _initialize();
  }

  void _initialize() {
    _checkSession();

    // Listen to Supabase authentication state updates
    _authSubscription = _authService.supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session == null) {
        state = AuthState(isInitialized: true);
      } else {
        await _fetchUserData(session.user.id);
      }
    });
  }

  Future<void> _checkSession() async {
    final user = _authService.currentUser;
    if (user != null) {
      await _fetchUserData(user.id);
    } else {
      state = state.copyWith(isInitialized: true);
    }
  }

  Future<void> _fetchUserData(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userData = await _authService.getCurrentUserData();
      if (userData != null) {
        final userModel = UserModel.fromMap(userData);
        state = AuthState(
          userModel: userModel,
          isAuthenticated: true,
          isInitialized: true,
        );
      } else {
        state = AuthState(
          errorMessage: 'User profile not found in database.',
          isInitialized: true,
        );
      }
    } catch (e) {
      state = AuthState(
        errorMessage: 'Failed to retrieve profile: ${e.toString()}',
        isInitialized: true,
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signIn(email: email, password: password);
    } on supabase.AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signOut();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to sign out: ${e.toString()}',
      );
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

final authViewModelProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});