import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';

final authServiceProvider = Provider((ref) => TMDBService());

class AuthState {
  final bool isLoading;
  final String? error;
  final String? sessionId;
  final String? username;

  AuthState({
    this.isLoading = false,
    this.error,
    this.sessionId,
    this.username,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? sessionId,
    String? username,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sessionId: sessionId ?? this.sessionId,
      username: username ?? this.username,
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
      final sessionId = response['session_id'] as String;
      
      // Get account details after successful login
      final accountDetails = await _authService.getAccountDetails(sessionId);
      
      state = state.copyWith(
        isLoading: false,
        sessionId: sessionId,
        username: accountDetails['username'] as String,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        sessionId: null,
        username: null,
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