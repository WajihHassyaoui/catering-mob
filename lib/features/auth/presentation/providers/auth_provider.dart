import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/auth_repository.dart';

// ── Providers ────────────────────────────────────────────────────────────────

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(secureStorageProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// ── State ────────────────────────────────────────────────────────────────────

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        error: error ?? this.error,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repo.getCurrentUser();
      if (user != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final result = await _repo.login(email: email, password: password);
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<UserModel?> registerClient({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? inviteCode,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repo.registerClient(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        inviteCode: inviteCode,
      );
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return user;
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
      return null;
    }
  }

  Future<UserModel?> registerCompany({
    required String companyName,
    required String adminFullName,
    required String email,
    required String phone,
    required String industry,
    required String size,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repo.registerCompany(
        companyName: companyName,
        adminFullName: adminFullName,
        email: email,
        phone: phone,
        industry: industry,
        size: size,
        password: password,
      );
      // Company starts as unauthenticated (pending approval)
      state = const AuthState(status: AuthStatus.unauthenticated);
      return user;
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
      return null;
    }
  }

  Future<void> forgotPassword(String email) async {
    await _repo.forgotPassword(email);
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(status: AuthStatus.unauthenticated, error: null);
    }
  }
}
