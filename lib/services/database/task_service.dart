import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskServiceProvider = Provider((ref) => TaskService());

class TaskService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<TaskModel>> getTasks({String? companyId, String? assigneeId}) async {
    var query = _supabase.from('tasks').select();
    
    if (companyId != null) {
      query = query.eq('company_id', companyId);
    }
    if (assigneeId != null) {
      query = query.eq('assignee_id', assigneeId);
    }
    
    final response = await query.order('created_at', ascending: false);
    return (response as List).map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> addTask(Map<String, dynamic> taskData) async {
    await _supabase.from('tasks').insert(taskData);
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    await _supabase.from('tasks').update({'status': status}).eq('id', taskId);
  }
}
