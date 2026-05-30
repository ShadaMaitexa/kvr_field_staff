import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../models/visit_model.dart';
import '../services/database/task_service.dart';
import '../services/database/visit_service.dart';
import '../services/storage/storage_service.dart';
import 'auth_viewmodel.dart';

// ─── State ────────────────────────────────────────────────────────────────────
class StaffState {
  final bool isLoadingLocation;
  final bool isLoadingData;
  final bool isSavingVisit;
  final Position? currentPosition;
  final String locationStatus;
  final File? capturedImage;
  final List<TaskModel> tasks;
  final List<VisitModel> visits;
  final VisitModel? lastSavedVisit;
  final String? error;

  const StaffState({
    this.isLoadingLocation = false,
    this.isLoadingData = false,
    this.isSavingVisit = false,
    this.currentPosition,
    this.locationStatus = 'Fetching GPS...',
    this.capturedImage,
    this.tasks = const [],
    this.visits = const [],
    this.lastSavedVisit,
    this.error,
  });

  StaffState copyWith({
    bool? isLoadingLocation,
    bool? isLoadingData,
    bool? isSavingVisit,
    Position? currentPosition,
    String? locationStatus,
    File? capturedImage,
    bool clearImage = false,
    List<TaskModel>? tasks,
    List<VisitModel>? visits,
    VisitModel? lastSavedVisit,
    String? error,
  }) {
    return StaffState(
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      isLoadingData: isLoadingData ?? this.isLoadingData,
      isSavingVisit: isSavingVisit ?? this.isSavingVisit,
      currentPosition: currentPosition ?? this.currentPosition,
      locationStatus: locationStatus ?? this.locationStatus,
      capturedImage: clearImage ? null : (capturedImage ?? this.capturedImage),
      tasks: tasks ?? this.tasks,
      visits: visits ?? this.visits,
      lastSavedVisit: lastSavedVisit ?? this.lastSavedVisit,
      error: error,
    );
  }

  double get totalDistanceKm =>
      visits.fold(0.0, (sum, v) => sum + (v.distanceInKm ?? 0.0));

  int get todayVisitCount {
    final today = DateTime.now();
    return visits
        .where((v) =>
            v.createdAt.year == today.year &&
            v.createdAt.month == today.month &&
            v.createdAt.day == today.day)
        .length;
  }

  int get pendingTaskCount =>
      tasks.where((t) => t.status == 'pending').length;

  int get completedTaskCount =>
      tasks.where((t) => t.status == 'completed').length;
}

// ─── Notifier ─────────────────────────────────────────────────────────────────
class StaffNotifier extends StateNotifier<StaffState> {
  final TaskService _taskService;
  final VisitService _visitService;
  final StorageService _storageService;
  final String? _staffId;
  final String? _companyId;

  StaffNotifier({
    required TaskService taskService,
    required VisitService visitService,
    required StorageService storageService,
    String? staffId,
    String? companyId,
  })  : _taskService = taskService,
        _visitService = visitService,
        _storageService = storageService,
        _staffId = staffId,
        _companyId = companyId,
        super(const StaffState()) {
    if (_staffId != null) {
      loadData();
      fetchLocation();
    }
  }

  // ─── Data Loading ──────────────────────────────────────────────────────────
  Future<void> loadData() async {
    if (_staffId == null) return;
    state = state.copyWith(isLoadingData: true, error: null);
    try {
      final results = await Future.wait([
        _taskService.getTasks(assigneeId: _staffId),
        _visitService.getVisits(staffId: _staffId),
      ]);
      state = state.copyWith(
        isLoadingData: false,
        tasks: results[0] as List<TaskModel>,
        visits: results[1] as List<VisitModel>,
      );
    } catch (e) {
      state = state.copyWith(isLoadingData: false, error: e.toString());
    }
  }

  // ─── GPS ───────────────────────────────────────────────────────────────────
  Future<void> fetchLocation() async {
    state = state.copyWith(
        isLoadingLocation: true, locationStatus: 'Requesting permission...');
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoadingLocation: false,
          locationStatus: 'Location permission denied permanently.',
          error: 'Enable location permission in settings.',
        );
        return;
      }

      state = state.copyWith(locationStatus: 'Acquiring GPS signal...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      state = state.copyWith(
        isLoadingLocation: false,
        currentPosition: position,
        locationStatus:
            '${position.latitude.toStringAsFixed(4)}° N, ${position.longitude.toStringAsFixed(4)}° E',
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingLocation: false,
        locationStatus: 'Could not get location.',
        error: e.toString(),
      );
    }
  }

  // ─── Camera ────────────────────────────────────────────────────────────────
  Future<void> capturePhoto() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1280,
      );
      if (picked != null) {
        state = state.copyWith(capturedImage: File(picked.path), error: null);
      }
    } catch (e) {
      state = state.copyWith(error: 'Camera error: ${e.toString()}');
    }
  }

  void clearPhoto() => state = state.copyWith(clearImage: true);

  // ─── Save Visit ────────────────────────────────────────────────────────────
  Future<bool> saveVisit(String locationName, String notes) async {
    if (_staffId == null || state.currentPosition == null) return false;
    state = state.copyWith(isSavingVisit: true, error: null);
    try {
      String? photoUrl;
      if (state.capturedImage != null) {
        photoUrl =
            await _storageService.uploadVisitPhoto(state.capturedImage!, _staffId);
      }

      final visitId = const Uuid().v4();
      final now = DateTime.now();

      // Calculate distance from last visit (simple straight-line)
      double? distanceKm;
      if (state.visits.isNotEmpty) {
        final last = state.visits.first;
        distanceKm = Geolocator.distanceBetween(
              last.latitude,
              last.longitude,
              state.currentPosition!.latitude,
              state.currentPosition!.longitude,
            ) /
            1000.0;
      }

      final visitData = {
        'id': visitId,
        'staff_id': _staffId,
        'company_id': _companyId,
        'location_name': locationName.isNotEmpty ? locationName : 'Field Visit',
        'latitude': state.currentPosition!.latitude,
        'longitude': state.currentPosition!.longitude,
        'photo_url': photoUrl,
        'notes': notes.isNotEmpty ? notes : null,
        'distance_in_km': distanceKm,
        'created_at': now.toIso8601String(),
      };

      await _visitService.addVisit(visitData);

      final savedVisit = VisitModel(
        id: visitId,
        staffId: _staffId,
        companyId: _companyId,
        locationName: visitData['location_name'] as String,
        latitude: state.currentPosition!.latitude,
        longitude: state.currentPosition!.longitude,
        photoUrl: photoUrl,
        notes: notes.isNotEmpty ? notes : null,
        distanceInKm: distanceKm,
        createdAt: now,
      );

      state = state.copyWith(
        isSavingVisit: false,
        lastSavedVisit: savedVisit,
        clearImage: true,
      );
      await loadData(); // Refresh lists
      return true;
    } catch (e) {
      state = state.copyWith(isSavingVisit: false, error: e.toString());
      return false;
    }
  }

  // ─── Tasks ─────────────────────────────────────────────────────────────────
  Future<void> markTaskComplete(String taskId) async {
    try {
      await _taskService.updateTaskStatus(taskId, 'completed');
      await loadData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────
final staffViewModelProvider =
    StateNotifierProvider<StaffNotifier, StaffState>((ref) {
  final user = ref.watch(authViewModelProvider).userModel;
  return StaffNotifier(
    taskService: ref.read(taskServiceProvider),
    visitService: ref.read(visitServiceProvider),
    storageService: ref.read(storageServiceProvider),
    staffId: user?.id,
    companyId: user?.companyId,
  );
});
