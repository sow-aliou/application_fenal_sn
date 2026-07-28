import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// A future provider to check if the user is logged in
final authStateProvider = FutureProvider<bool>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.isLoggedIn();
});
