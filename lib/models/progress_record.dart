class ProgressEntry {
  final String date;
  double weight;
  int chest;
  int waist;
  int hips;
  int arms;
  String notes;

  ProgressEntry({
    required this.date,
    required this.weight,
    required this.chest,
    required this.waist,
    required this.hips,
    required this.arms,
    required this.notes,
  });

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      date: json['date'],
      weight: (json['weight'] as num).toDouble(),
      chest: json['chest'],
      waist: json['waist'],
      hips: json['hips'],
      arms: json['arms'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'weight': weight,
        'chest': chest,
        'waist': waist,
        'hips': hips,
        'arms': arms,
        'notes': notes,
      };
}

class ProgressRecord {
  final String id;
  final String memberId;
  List<ProgressEntry> entries;

  ProgressRecord({
    required this.id,
    required this.memberId,
    required this.entries,
  });

  factory ProgressRecord.fromJson(Map<String, dynamic> json) {
    return ProgressRecord(
      id: json['id'],
      memberId: json['memberId'],
      entries: (json['entries'] as List)
          .map((e) => ProgressEntry.fromJson(e))
          .toList(),
    );
  }
}
