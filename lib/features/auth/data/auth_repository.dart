import '../../../core/storage/secure_storage.dart';
import '../../../shared/mock_data/mock_data.dart';
import '../../../shared/models/user_model.dart';

class AuthRepository {
  final SecureStorage _storage;

  AuthRepository(this._storage);

  // Simulates network delay for realistic MVP feel
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 900));

  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    await _delay();

    // Mock authentication — matches demo accounts by email
    final user = _mockUserByEmail(email);
    if (user == null) {
      throw Exception('No account found with that email address.');
    }
    if (password != 'Password1') {
      throw Exception('Incorrect password. Please try again.');
    }

    final token =
        'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
    await _storage.saveToken(token);
    await _storage.saveRefreshToken('mock_refresh_${user.id}');
    await _storage.saveUserRole(user.role);
    await _storage.saveUserId(user.id);

    return (user: user, token: token);
  }

  Future<UserModel> registerClient({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? inviteCode,
  }) async {
    await _delay();

    final user = UserModel(
      id: 'u_new_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      phone: phone,
      role: 'client',
      isEmailVerified: false,
      createdAt: DateTime.now(),
    );

    final token = 'mock_token_${user.id}';
    await _storage.saveToken(token);
    await _storage.saveUserRole('client');
    await _storage.saveUserId(user.id);

    return user;
  }

  Future<UserModel> registerCompany({
    required String companyName,
    required String adminFullName,
    required String email,
    required String phone,
    required String industry,
    required String size,
    required String password,
  }) async {
    await _delay();

    final user = UserModel(
      id: 'u_co_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: adminFullName,
      phone: phone,
      role: 'company',
      isEmailVerified: false,
      createdAt: DateTime.now(),
    );

    final token = 'mock_token_${user.id}';
    await _storage.saveToken(token);
    await _storage.saveUserRole('company');
    await _storage.saveUserId(user.id);

    return user;
  }

  Future<void> forgotPassword(String email) async {
    await _delay();
    // Mock: always succeeds
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

  Future<UserModel?> getCurrentUser() async {
    final token = await _storage.getToken();
    if (token == null) return null;

    final userId = await _storage.getUserId();
    final role = await _storage.getUserRole();
    if (userId == null || role == null) return null;

    return _mockUserByRole(role);
  }

  UserModel? _mockUserByEmail(String email) {
    switch (email.toLowerCase().trim()) {
      case 'alex.morgan@email.com':
        return MockData.clientUser;
      case 'admin@techflow.com':
        return MockData.companyUser;
      case 'admin@plattercatering.com':
        return MockData.adminUser;
      default:
        return null;
    }
  }

  UserModel? _mockUserByRole(String role) {
    switch (role) {
      case 'client':
        return MockData.clientUser;
      case 'company':
        return MockData.companyUser;
      case 'admin':
        return MockData.adminUser;
      default:
        return null;
    }
  }
}
