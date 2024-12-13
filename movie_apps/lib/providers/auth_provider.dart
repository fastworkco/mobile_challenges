import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';

final authServiceProvider = Provider((ref) => TMDBService());

class AuthState {
  final bool isLoading;
  final String? error;
  final String? sessionId;

  AuthState({
    this.isLoading = false,
    this.error,
    this.sessionId,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? sessionId,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final TMDBService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.login(username, password);
      state = state.copyWith(
        isLoading: false,
        sessionId: response['session_id'] as String,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        sessionId: null,
      );
    }
  }

  void logout() {
    state = AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});