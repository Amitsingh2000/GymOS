import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/member.dart';
import '../models/exercise.dart';
import '../models/equipment.dart';
import '../models/trainer.dart';
import '../models/membership_plan.dart';
import '../models/diet_plan.dart';
import '../models/workout_plan.dart';
import '../models/nutrition_log.dart';
import '../models/progress_record.dart';

class DataService {
  static DataService? _instance;
  static DataService get instance => _instance ??= DataService._();
  DataService._();

  List<Member>? _members;
  List<Exercise>? _exercises;
  List<GymEquipment>? _equipment;
  List<Trainer>? _trainers;
  List<MembershipPlan>? _membershipPlans;
  List<DietPlan>? _dietPlans;
  List<WorkoutPlan>? _workoutPlans;
  List<NutritionLog>? _nutritionLogs;
  List<ProgressRecord>? _progressRecords;

  Future<T> _load<T>(
    String path,
    T Function(List<dynamic>) parser,
  ) async {
    final json = await rootBundle.loadString(path);
    final data = jsonDecode(json) as List<dynamic>;
    return parser(data);
  }

  Future<List<Member>> getMembers() async {
    _members ??= await _load(
      'assets/mock_data/members.json',
      (data) => data.map((e) => Member.fromJson(e)).toList(),
    );
    return _members!;
  }

  Future<List<Exercise>> getExercises() async {
    _exercises ??= await _load(
      'assets/mock_data/exercises.json',
      (data) => data.map((e) => Exercise.fromJson(e)).toList(),
    );
    return _exercises!;
  }

  Future<List<GymEquipment>> getEquipment() async {
    _equipment ??= await _load(
      'assets/mock_data/equipment.json',
      (data) => data.map((e) => GymEquipment.fromJson(e)).toList(),
    );
    return _equipment!;
  }

  Future<List<Trainer>> getTrainers() async {
    _trainers ??= await _load(
      'assets/mock_data/trainers.json',
      (data) => data.map((e) => Trainer.fromJson(e)).toList(),
    );
    return _trainers!;
  }

  Future<List<MembershipPlan>> getMembershipPlans() async {
    _membershipPlans ??= await _load(
      'assets/mock_data/membership_plans.json',
      (data) => data.map((e) => MembershipPlan.fromJson(e)).toList(),
    );
    return _membershipPlans!;
  }

  Future<List<DietPlan>> getDietPlans() async {
    _dietPlans ??= await _load(
      'assets/mock_data/diet_plans.json',
      (data) => data.map((e) => DietPlan.fromJson(e)).toList(),
    );
    return _dietPlans!;
  }

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    _workoutPlans ??= await _load(
      'assets/mock_data/workout_plans.json',
      (data) => data.map((e) => WorkoutPlan.fromJson(e)).toList(),
    );
    return _workoutPlans!;
  }

  Future<List<NutritionLog>> getNutritionLogs() async {
    _nutritionLogs ??= await _load(
      'assets/mock_data/nutrition_logs.json',
      (data) => data.map((e) => NutritionLog.fromJson(e)).toList(),
    );
    return _nutritionLogs!;
  }

  Future<List<ProgressRecord>> getProgressRecords() async {
    _progressRecords ??= await _load(
      'assets/mock_data/progress.json',
      (data) => data.map((e) => ProgressRecord.fromJson(e)).toList(),
    );
    return _progressRecords!;
  }

  // Analytics helpers
  Future<Map<String, dynamic>> getDashboardStats() async {
    final members = await getMembers();
    final plans = await getMembershipPlans();
    final active = members.where((m) => m.isActive).length;
    final revenue = members.where((m) => m.isActive).fold<double>(0, (sum, m) {
      final plan = plans.firstWhere(
        (p) => p.id == m.membershipPlanId,
        orElse: () => plans.first,
      );
      return sum + plan.monthlyPrice;
    });

    return {
      'totalMembers': members.length,
      'activeMembers': active,
      'inactiveMembers': members.length - active,
      'monthlyRevenue': revenue,
    };
  }

  // Mutable list helpers for in-session changes
  void addWorkoutPlan(WorkoutPlan plan) {
    _workoutPlans ??= [];
    _workoutPlans!.add(plan);
  }

  void updateWorkoutPlanStatus(String planId, String status, String? feedback) {
    final plan = _workoutPlans?.firstWhere((p) => p.id == planId);
    if (plan != null) {
      plan.status = status;
      plan.trainerFeedback = feedback;
    }
  }

  void addNutritionEntry(String logId, NutritionEntry entry) {
    final log = _nutritionLogs?.firstWhere((l) => l.id == logId);
    if (log != null) {
      log.entries.add(entry);
      log.totalCalories += entry.calories;
      log.totalProtein += entry.protein;
      log.totalCarbs += entry.carbs;
      log.totalFats += entry.fats;
    }
  }
}
