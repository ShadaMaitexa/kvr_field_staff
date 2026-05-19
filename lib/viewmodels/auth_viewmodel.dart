import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});