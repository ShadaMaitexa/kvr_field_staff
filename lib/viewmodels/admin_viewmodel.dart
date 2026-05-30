import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/visit_model.dart';
import '../models/task_model.dart';
import '../services/database/task_service.dart';
import '../services/database/visit_service.dart';
import '../services/database/user_service.dart';
import 'auth_viewmodel.dart';

final adminViewModelProvider = StateNotifierProvider<AdminViewModel, AdminState>((ref) {
  final user = ref.watch(authViewModelProvider).userModel;
  return AdminViewModel(
    taskService: ref.read(taskServiceProvider),
    visitService: ref.read(visitServiceProvider),
    userService: ref.read(userServiceProvider),
    companyId: user?.companyId,
    adminId: user?.id,
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
      error: error,
    );
  }
}

class AdminViewModel extends StateNotifier<AdminState> {
  final TaskService _taskService;
  final VisitService _visitService;
  final UserService _userService;
  final String? _companyId;
  final String? _adminId;

  AdminViewModel({
    required TaskService taskService,
    required VisitService visitService,
    required UserService userService,
    String? companyId,
    String? adminId,
  })  : _taskService = taskService,
        _visitService = visitService,
        _userService = userService,
        _companyId = companyId,
        _adminId = adminId,
        super(AdminState()) {
    if (_companyId != null) {
      loadDashboardData();
    }
  }

  Future<void> loadDashboardData() async {
    if (_companyId == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _visitService.getVisits(companyId: _companyId),
        _taskService.getTasks(companyId: _companyId),
        _userService.getStaffByCompany(_companyId),
      ]);

      final visits = results[0] as List<VisitModel>;
      final tasks = results[1] as List<TaskModel>;
      final staff = results[2] as List<UserModel>;

      final pendingTasksCount = tasks.where((t) => t.status == 'pending').length;
      final activeCount = staff.where((s) => s.status == 'active').length;

      state = state.copyWith(
        isLoading: false,
        recentVisits: visits,
        recentTasks: tasks,
        staffList: staff,
        activeStaffCount: activeCount,
        pendingTasks: pendingTasksCount,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> assignTask({
    required String title,
    required String description,
    required String assigneeId,
    required DateTime dueDate,
  }) async {
    if (_companyId == null || _adminId == null) return;
    try {
      await _taskService.addTask({
        'title': title,
        'description': description,
        'assignee_id': assigneeId,
        'assigner_id': _adminId,
        'company_id': _companyId,
        'due_date': dueDate.toIso8601String(),
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });
      await loadDashboardData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleStaffStatus(String userId, String currentStatus) async {
    try {
      final newStatus = currentStatus == 'active' ? 'inactive' : 'active';
      await _userService.updateUserStatus(userId, newStatus);
      await loadDashboardData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addStaff({
    required String name,
    required String email,
    String? phone,
  }) async {
    if (_companyId == null) return;
    try {
      await _userService.createUser(
        email: email,
        password: 'TempPass123!', // Default password — user should reset
        name: name,
        role: 'staff',
        companyId: _companyId,
        phone: phone,
      );
      await loadDashboardData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
