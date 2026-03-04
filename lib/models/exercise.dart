class Exercise {
  final String id;
  final String name;
  final String description;
  final List<String> muscleGroups;
  final String difficulty;
  final String? equipmentId;
  final String equipmentName;
  final String videoId;
  final int suggestedSets;
  final String suggestedReps;
  final int restTime;
  final int calories;
  final List<String> tags;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroups,
    required this.difficulty,
    this.equipmentId,
    required this.equipmentName,
    required this.videoId,
    required this.suggestedSets,
    required this.suggestedReps,
    required this.restTime,
    required this.calories,
    required this.tags,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      muscleGroups: List<String>.from(json['muscleGroups']),
      difficulty: json['difficulty'],
      equipmentId: json['equipmentId'],
      equipmentName: json['equipmentName'],
      videoId: json['videoId'],
      suggestedSets: json['suggestedSets'],
      suggestedReps: json['suggestedReps'],
      restTime: json['restTime'],
      calories: json['calories'],
      tags: List<String>.from(json['tags']),
    );
  }
}
