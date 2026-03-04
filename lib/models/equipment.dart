class DowntimeLog {
  final String date;
  final String reason;
  final String duration;

  DowntimeLog({required this.date, required this.reason, required this.duration});

  factory DowntimeLog.fromJson(Map<String, dynamic> json) {
    return DowntimeLog(
      date: json['date'],
      reason: json['reason'],
      duration: json['duration'],
    );
  }
}

class GymEquipment {
  final String id;
  final String name;
  final String category;
  final String brand;
  final String condition;
  final String purchaseDate;
  final String lastMaintenanceDate;
  final String nextMaintenanceDue;
  final String location;
  final List<DowntimeLog> downtimeLogs;
  final String imageUrl;

  GymEquipment({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.condition,
    required this.purchaseDate,
    required this.lastMaintenanceDate,
    required this.nextMaintenanceDue,
    required this.location,
    required this.downtimeLogs,
    required this.imageUrl,
  });

  factory GymEquipment.fromJson(Map<String, dynamic> json) {
    return GymEquipment(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      brand: json['brand'],
      condition: json['condition'],
      purchaseDate: json['purchaseDate'],
      lastMaintenanceDate: json['lastMaintenanceDate'],
      nextMaintenanceDue: json['nextMaintenanceDue'],
      location: json['location'],
      downtimeLogs: (json['downtimeLogs'] as List)
          .map((d) => DowntimeLog.fromJson(d))
          .toList(),
      imageUrl: json['imageUrl'],
    );
  }
}
