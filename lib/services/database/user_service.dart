import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';

final userServiceProvider = Provider((ref) => UserService());

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<UserModel>> getStaffByCompany(String companyId) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('company_id', companyId)
        .eq('role', 'staff')
        .order('name');
    return (response as List).map((e) => UserModel.fromMap(e)).toList();
  }

  Future<List<UserModel>> getAdminsByCompany(String companyId) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('company_id', companyId)
        .eq('role', 'admin')
        .order('name');
    return (response as List).map((e) => UserModel.fromMap(e)).toList();
  }

  Future<void> updateUserStatus(String userId, String status) async {
    await _supabase
        .from('users')
        .update({'status': status}).eq('id', userId);
  }

  Future<void> deleteUserProfile(String userId) async {
    await _supabase.from('users').delete().eq('id', userId);
  }

  /// Creates auth user + profile. Assumes email confirmation is ON so
  /// the current admin session is not replaced by the new user's session.
  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required String companyId,
    String? phone,
  }) async {
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    final userId = res.user?.id;
    if (userId == null) throw Exception('Failed to create user.');

    await _supabase.from('users').insert({
      'id': userId,
      'name': name,
      'email': email,
      'role': role,
      'company_id': companyId,
      'status': 'active',
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    });
  }
}
