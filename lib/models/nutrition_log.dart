class NutritionEntry {
  final String food;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;

  NutritionEntry({
    required this.food,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  factory NutritionEntry.fromJson(Map<String, dynamic> json) {
    return NutritionEntry(
      food: json['food'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fats: json['fats'],
    );
  }

  Map<String, dynamic> toJson() => {
        'food': food,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
      };
}

class NutritionLog {
  final String id;
  final String memberId;
  final String date;
  int totalCalories;
  int totalProtein;
  int totalCarbs;
  int totalFats;
  List<NutritionEntry> entries;

  NutritionLog({
    required this.id,
    required this.memberId,
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.entries,
  });

  factory NutritionLog.fromJson(Map<String, dynamic> json) {
    return NutritionLog(
      id: json['id'],
      memberId: json['memberId'],
      date: json['date'],
      totalCalories: json['totalCalories'],
      totalProtein: json['totalProtein'],
      totalCarbs: json['totalCarbs'],
      totalFats: json['totalFats'],
      entries: (json['entries'] as List)
          .map((e) => NutritionEntry.fromJson(e))
          .toList(),
    );
  }
}
