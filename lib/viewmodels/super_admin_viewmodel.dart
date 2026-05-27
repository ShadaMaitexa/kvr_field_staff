import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/company_model.dart';
import '../services/database/company_service.dart';
import '../services/database/task_service.dart';
import '../services/database/visit_service.dart';

final superAdminViewModelProvider = StateNotifierProvider<SuperAdminViewModel, SuperAdminState>((ref) {
  return SuperAdminViewModel(
    companyService: ref.read(companyServiceProvider),
    taskService: ref.read(taskServiceProvider),
    visitService: ref.read(visitServiceProvider),
  );
});

class SuperAdminState {
  final bool isLoading;
  final List<CompanyModel> companies;
  final int totalAdmins;
  final int activeStaff;
  final int visitsToday;
  final String? error;

  SuperAdminState({
    this.isLoading = false,
    this.companies = const [],
    this.totalAdmins = 0,
    this.activeStaff = 0,
    this.visitsToday = 0,
    this.error,
  });

  SuperAdminState copyWith({
    bool? isLoading,
    List<CompanyModel>? companies,
    int? totalAdmins,
    int? activeStaff,
    int? visitsToday,
    String? error,
  }) {
    return SuperAdminState(
      isLoading: isLoading ?? this.isLoading,
      companies: companies ?? this.companies,
      totalAdmins: totalAdmins ?? this.totalAdmins,
      activeStaff: activeStaff ?? this.activeStaff,
      visitsToday: visitsToday ?? this.visitsToday,
      error: error ?? this.error,
    );
  }
}

class SuperAdminViewModel extends StateNotifier<SuperAdminState> {
  final CompanyService _companyService;
  final TaskService _taskService;
  final VisitService _visitService;

  SuperAdminViewModel({
    required CompanyService companyService,
    required TaskService taskService,
    required VisitService visitService,
  })  : _companyService = companyService,
        _taskService = taskService,
        _visitService = visitService,
        super(SuperAdminState()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final companies = await _companyService.getCompanies();
      final visits = await _visitService.getVisits(date: DateTime.now());
      
      // Calculate dummy stats based on companies since we don't have separate admin/staff models yet
      int activeStaffCount = companies.fold(0, (sum, item) => sum + item.staffCount);
      
      state = state.copyWith(
        isLoading: false,
        companies: companies,
        totalAdmins: companies.length * 2, // Dummy logic
        activeStaff: activeStaffCount,
        visitsToday: visits.length,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addCompany(String name) async {
    try {
      await _companyService.addCompany(name);
      await loadDashboardData(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
