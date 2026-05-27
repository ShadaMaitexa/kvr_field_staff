import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/visit_model.dart';
import '../models/task_model.dart';
import '../services/database/task_service.dart';
import '../services/database/visit_service.dart';
import 'auth_viewmodel.dart';

final adminViewModelProvider = StateNotifierProvider<AdminViewModel, AdminState>((ref) {
  final user = ref.watch(authViewModelProvider).userModel;
  return AdminViewModel(
    taskService: ref.read(taskServiceProvider),
    visitService: ref.read(visitServiceProvider),
    companyId: user?.companyId,
  );
});

class AdminState {
  final bool isLoading;
  final List<UserModel> staffList;
  final List<VisitModel> recentVisits;
  final List<TaskModel> recentTasks;
  final int activeStaffCount;
  final int pendingTasks;
  final String? error;

  AdminState({
    this.isLoading = false,
    this.staffList = const [],
    this.recentVisits = const [],
    this.recentTasks = const [],
    this.activeStaffCount = 0,
    this.pendingTasks = 0,
    this.error,
  });

  AdminState copyWith({
    bool? isLoading,
    List<UserModel>? staffList,
    List<VisitModel>? recentVisits,
    List<TaskModel>? recentTasks,
    int? activeStaffCount,
    int? pendingTasks,
    String? error,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      staffList: staffList ?? this.staffList,
      recentVisits: recentVisits ?? this.recentVisits,
      recentTasks: recentTasks ?? this.recentTasks,
      activeStaffCount: activeStaffCount ?? this.activeStaffCount,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      error: error ?? this.error,
    );
  }
}

class AdminViewModel extends StateNotifier<AdminState> {
  final TaskService _taskService;
  final VisitService _visitService;
  final String? _companyId;

  AdminViewModel({
    required TaskService taskService,
    required VisitService visitService,
    String? companyId,
  })  : _taskService = taskService,
        _visitService = visitService,
        _companyId = companyId,
        super(AdminState()) {
    if (_companyId != null) {
      loadDashboardData();
    }
  }

  Future<void> loadDashboardData() async {
    if (_companyId == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      final visits = await _visitService.getVisits(companyId: _companyId);
      final tasks = await _taskService.getTasks(companyId: _companyId);
      
      final pendingTasksCount = tasks.where((t) => t.status == 'pending').length;
      
      state = state.copyWith(
        isLoading: false,
        recentVisits: visits,
        recentTasks: tasks,
        activeStaffCount: 0, // Need to implement staff fetching later
        pendingTasks: pendingTasksCount,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
