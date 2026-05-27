import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/company_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final companyServiceProvider = Provider((ref) => CompanyService());

class CompanyService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<CompanyModel>> getCompanies() async {
    final response = await _supabase.from('companies').select();
    return (response as List).map((e) => CompanyModel.fromMap(e)).toList();
  }

  Future<void> addCompany(String name) async {
    await _supabase.from('companies').insert({'name': name});
  }

  Future<void> deleteCompany(String id) async {
    await _supabase.from('companies').delete().eq('id', id);
  }
}
