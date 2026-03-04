class WorkoutExercise {
  final String exerciseId;
  final int sets;
  final String reps;
  final int rest;

  WorkoutExercise({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.rest,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exerciseId: json['exerciseId'],
      sets: json['sets'],
      reps: json['reps'].toString(),
      rest: json['rest'],
    );
  }

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'sets': sets,
        'reps': reps,
        'rest': rest,
      };
}

class WorkoutDay {
  final String day;
  final String focus;
  final List<WorkoutExercise> exercises;

  WorkoutDay({
    required this.day,
    required this.focus,
    required this.exercises,
  });

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      day: json['day'],
      focus: json['focus'],
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'focus': focus,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };
}

class WorkoutPlan {
  final String id;
  final String memberId;
  final String name;
  String status; // pending, approved, rejected
  final String submittedDate;
  String? reviewedDate;
  String? trainerId;
  String? trainerFeedback;
  final List<WorkoutDay> days;

  WorkoutPlan({
    required this.id,
    required this.memberId,
    required this.name,
    required this.status,
    required this.submittedDate,
    this.reviewedDate,
    this.trainerId,
    this.trainerFeedback,
    required this.days,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'],
      memberId: json['memberId'],
      name: json['name'],
      status: json['status'],
      submittedDate: json['submittedDate'],
      reviewedDate: json['reviewedDate'],
      trainerId: json['trainerId'],
      trainerFeedback: json['trainerFeedback'],
      days: (json['days'] as List).map((d) => WorkoutDay.fromJson(d)).toList(),
    );
  }
}
