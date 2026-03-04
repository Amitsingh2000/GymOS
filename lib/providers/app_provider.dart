import 'package:flutter/material.dart';
import '../models/member.dart';
import '../models/exercise.dart';
import '../models/equipment.dart';
import '../models/trainer.dart';
import '../models/membership_plan.dart';
import '../models/diet_plan.dart';
import '../models/workout_plan.dart';
import '../models/nutrition_log.dart';
import '../models/progress_record.dart';
import '../services/data_service.dart';

enum AppRole { owner, member }

class AppProvider extends ChangeNotifier {
  // ---- Role / Auth ----
  AppRole _role = AppRole.member;
  AppRole get role => _role;

  final String _currentMemberId = 'm1'; // default logged-in member
  String get currentMemberId => _currentMemberId;

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  void setRole(AppRole role) {
    _role = role;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ---- Data ----
  List<Member> members = [];
  List<Exercise> exercises = [];
  List<GymEquipment> equipment = [];
  List<Trainer> trainers = [];
  List<MembershipPlan> membershipPlans = [];
  List<DietPlan> dietPlans = [];
  List<WorkoutPlan> workoutPlans = [];
  List<NutritionLog> nutritionLogs = [];
  List<ProgressRecord> progressRecords = [];

  bool isLoading = false;

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();
    try {
      members = await DataService.instance.getMembers();
      exercises = await DataService.instance.getExercises();
      equipment = await DataService.instance.getEquipment();
      trainers = await DataService.instance.getTrainers();
      membershipPlans = await DataService.instance.getMembershipPlans();
      dietPlans = await DataService.instance.getDietPlans();
      workoutPlans = await DataService.instance.getWorkoutPlans();
      nutritionLogs = await DataService.instance.getNutritionLogs();
      progressRecords = await DataService.instance.getProgressRecords();
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  // ---- Getters ----
  Member? get currentMember => members.isEmpty
      ? null
      : members.firstWhere((m) => m.id == _currentMemberId,
          orElse: () => members.first);

  MembershipPlan? planForMember(Member m) {
    try {
      return membershipPlans.firstWhere((p) => p.id == m.membershipPlanId);
    } catch (_) {
      return null;
    }
  }

  Trainer? trainerForMember(Member m) {
    if (m.trainerId == null) return null;
    try {
      return trainers.firstWhere((t) => t.id == m.trainerId);
    } catch (_) {
      return null;
    }
  }

  List<WorkoutPlan> get currentMemberWorkoutPlans =>
      workoutPlans.where((wp) => wp.memberId == _currentMemberId).toList();

  List<WorkoutPlan> get pendingWorkoutPlans =>
      workoutPlans.where((wp) => wp.status == 'pending').toList();

  NutritionLog? get todaysNutritionLog {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    try {
      return nutritionLogs.firstWhere(
          (l) => l.memberId == _currentMemberId && l.date == today);
    } catch (_) {
      return nutritionLogs.isNotEmpty ? nutritionLogs.first : null;
    }
  }

  ProgressRecord? get currentMemberProgress {
    try {
      return progressRecords
          .firstWhere((p) => p.memberId == _currentMemberId);
    } catch (_) {
      return null;
    }
  }

  int get activeMembers => members.where((m) => m.isActive).length;
  double get monthlyRevenue => members.where((m) => m.isActive).fold(0, (s, m) {
        final plan = planForMember(m);
        return s + (plan?.monthlyPrice ?? 0);
      });

  // ---- Actions ----
  void submitWorkoutPlan(WorkoutPlan plan) {
    workoutPlans.add(plan);
    DataService.instance.addWorkoutPlan(plan);
    notifyListeners();
  }

  void reviewWorkoutPlan(String id, String status, String? feedback) {
    final idx = workoutPlans.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      workoutPlans[idx].status = status;
      workoutPlans[idx].trainerFeedback = feedback;
    }
    DataService.instance.updateWorkoutPlanStatus(id, status, feedback);
    notifyListeners();
  }

  void addFoodEntry(NutritionEntry entry) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final logIdx = nutritionLogs
        .indexWhere((l) => l.memberId == _currentMemberId && l.date == today);
    if (logIdx >= 0) {
      nutritionLogs[logIdx].entries.add(entry);
      nutritionLogs[logIdx].totalCalories += entry.calories;
      nutritionLogs[logIdx].totalProtein += entry.protein;
      nutritionLogs[logIdx].totalCarbs += entry.carbs;
      nutritionLogs[logIdx].totalFats += entry.fats;
    } else {
      final newLog = NutritionLog(
        id: 'nl_${DateTime.now().millisecondsSinceEpoch}',
        memberId: _currentMemberId,
        date: today,
        totalCalories: entry.calories,
        totalProtein: entry.protein,
        totalCarbs: entry.carbs,
        totalFats: entry.fats,
        entries: [entry],
      );
      nutritionLogs.add(newLog);
    }
    notifyListeners();
  }

  void addProgressEntry(ProgressEntry entry) {
    final idx =
        progressRecords.indexWhere((p) => p.memberId == _currentMemberId);
    if (idx >= 0) {
      progressRecords[idx].entries.add(entry);
    } else {
      progressRecords.add(ProgressRecord(
        id: 'pr_${DateTime.now().millisecondsSinceEpoch}',
        memberId: _currentMemberId,
        entries: [entry],
      ));
    }
    notifyListeners();
  }

  Exercise? exerciseById(String id) {
    try {
      return exercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
