import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/company_model.dart';
import '../models/visit_model.dart';
import '../models/user_model.dart';
import '../services/database/company_service.dart';
import '../services/database/visit_service.dart';
import '../services/database/user_service.dart';

final superAdminViewModelProvider =
    StateNotifierProvider<SuperAdminViewModel, SuperAdminState>((ref) {
  return SuperAdminViewModel(
    companyService: ref.read(companyServiceProvider),
    visitService: ref.read(visitServiceProvider),
    userService: ref.read(userServiceProvider),
  );
});

class SuperAdminState {
  final bool isLoading;
  final List<CompanyModel> companies;
  final List<VisitModel> globalVisits;
  final int totalAdmins;
  final int activeStaff;
  final int visitsToday;
  final String? error;

  SuperAdminState({
    this.isLoading = false,
    this.companies = const [],
    this.globalVisits = const [],
    this.totalAdmins = 0,
    this.activeStaff = 0,
    this.visitsToday = 0,
    this.error,
  });

  SuperAdminState copyWith({
    bool? isLoading,
    List<CompanyModel>? companies,
    List<VisitModel>? globalVisits,
    int? totalAdmins,
    int? activeStaff,
    int? visitsToday,
    String? error,
  }) {
    return SuperAdminState(
      isLoading: isLoading ?? this.isLoading,
      companies: companies ?? this.companies,
      globalVisits: globalVisits ?? this.globalVisits,
      totalAdmins: totalAdmins ?? this.totalAdmins,
      activeStaff: activeStaff ?? this.activeStaff,
      visitsToday: visitsToday ?? this.visitsToday,
      error: error,
    );
  }
}

class SuperAdminViewModel extends StateNotifier<SuperAdminState> {
  final CompanyService _companyService;
  final VisitService _visitService;
  final UserService _userService;

  SuperAdminViewModel({
    required CompanyService companyService,
    required VisitService visitService,
    required UserService userService,
  })  : _companyService = companyService,
        _visitService = visitService,
        _userService = userService,
        super(SuperAdminState()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final companies = await _companyService.getCompanies();
      final visits = await _visitService.getVisits(date: DateTime.now());

      int activeStaffCount =
          companies.fold(0, (sum, item) => sum + item.staffCount);

      state = state.copyWith(
        isLoading: false,
        companies: companies,
        globalVisits: visits,
        totalAdmins: companies.length * 2,
        activeStaff: activeStaffCount,
        visitsToday: visits.length,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadGlobalVisits({DateTime? date}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final visits = await _visitService.getVisits(date: date ?? DateTime.now());
      state = state.copyWith(isLoading: false, globalVisits: visits);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addCompany(String name) async {
    try {
      await _companyService.addCompany(name);
      await loadDashboardData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteCompany(String id) async {
    try {
      await _companyService.deleteCompany(id);
      await loadDashboardData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addAdmin({
    required String name,
    required String email,
    required String companyId,
  }) async {
    try {
      await _userService.createUser(
        email: email,
        password: 'AdminPass123!',
        name: name,
        role: 'admin',
        companyId: companyId,
      );
      await loadDashboardData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteAdmin(String userId) async {
    try {
      await _userService.deleteUserProfile(userId);
      await loadDashboardData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<List<UserModel>> getAdminsForCompany(String companyId) async {
    try {
      return await _userService.getAdminsByCompany(companyId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }
}
