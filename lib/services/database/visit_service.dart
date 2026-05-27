import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/visit_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final visitServiceProvider = Provider((ref) => VisitService());

class VisitService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<VisitModel>> getVisits({String? companyId, String? staffId, DateTime? date}) async {
    var query = _supabase.from('visits').select();
    
    if (companyId != null) {
      query = query.eq('company_id', companyId);
    }
    if (staffId != null) {
      query = query.eq('staff_id', staffId);
    }
    if (date != null) {
      final startOfDay = DateTime(date.year, date.month, date.day).toIso8601String();
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();
      query = query.gte('created_at', startOfDay).lte('created_at', endOfDay);
    }
    
    final response = await query.order('created_at', ascending: false);
    return (response as List).map((e) => VisitModel.fromMap(e)).toList();
  }

  Future<void> addVisit(Map<String, dynamic> visitData) async {
    await _supabase.from('visits').insert(visitData);
  }
}
