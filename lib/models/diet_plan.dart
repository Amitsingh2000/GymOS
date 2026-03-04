class MealItem {
  final String name;
  final String time;
  final int calories;
  final List<String> items;

  MealItem({
    required this.name,
    required this.time,
    required this.calories,
    required this.items,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      name: json['name'],
      time: json['time'],
      calories: json['calories'],
      items: List<String>.from(json['items']),
    );
  }
}

class DietPlan {
  final String id;
  final String name;
  final String goal;
  final int calorieTarget;
  final int protein;
  final int carbs;
  final int fats;
  final String color;
  final String description;
  final List<MealItem> meals;

  DietPlan({
    required this.id,
    required this.name,
    required this.goal,
    required this.calorieTarget,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.color,
    required this.description,
    required this.meals,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      id: json['id'],
      name: json['name'],
      goal: json['goal'],
      calorieTarget: json['calorieTarget'],
      protein: json['protein'],
      carbs: json['carbs'],
      fats: json['fats'],
      color: json['color'],
      description: json['description'],
      meals: (json['meals'] as List).map((m) => MealItem.fromJson(m)).toList(),
    );
  }
}
