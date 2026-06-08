// ─── Auth Service ─────────────────────────────────────────────────────────────
// Currently uses mock data. Replace _mockLogin() with real API calls.
// All methods return Future<T> — API-ready signature.

import '../models/app_models.dart';
import '../data/mock_data.dart';

class AuthResult {
  final bool success;
  final String? token;
  final UserModel? user;
  final String? error;
  const AuthResult({required this.success, this.token, this.user, this.error});
}

class AuthService {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ── Login ──────────────────────────────────────────────────────────────────
  // TODO: Replace with: POST /api/auth/login
  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network
    final user = MockData.users.where((u) => u.email == email).firstOrNull;
    if (user != null) {
      _currentUser = user;
      return AuthResult(success: true, token: 'mock_token_${user.id}', user: user);
    }
    return const AuthResult(success: false, error: 'Invalid email or password');
  }

  // ── Register ───────────────────────────────────────────────────────────────
  // TODO: Replace with: POST /api/auth/register
  Future<AuthResult> register({
    required String name, required String email, required String phone,
    required String password, required UserRole role, String? city,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final newUser = UserModel(
      id: 'NEW${DateTime.now().millisecondsSinceEpoch}',
      name: name, email: email, phone: phone, role: role,
      isVerified: role == UserRole.customer, // customers auto-verified via OTP
      city: city, createdAt: DateTime.now(),
    );
    _currentUser = newUser;
    return AuthResult(success: true, token: 'mock_token_new', user: newUser);
  }

  // ── OTP ────────────────────────────────────────────────────────────────────
  // TODO: Replace with: POST /api/auth/send-otp & POST /api/auth/verify-otp
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true; // always succeeds in mock
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return otp == '1234'; // mock OTP
  }

  // ── Forgot Password ────────────────────────────────────────────────────────
  // TODO: Replace with: POST /api/auth/forgot-password
  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.users.any((u) => u.email == email);
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  // TODO: Replace with: POST /api/auth/logout
  Future<void> logout() async {
    _currentUser = null;
  }
}
