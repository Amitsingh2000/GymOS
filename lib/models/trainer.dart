class Trainer {
  final String id;
  final String name;
  final String role;
  final List<String> specializations;
  final int commissionPercentage;
  final double monthlySalary;
  final List<String> assignedMemberIds;
  final List<String> certifications;
  final String joinDate;
  final String avatarUrl;
  final String email;
  final String phone;
  final double rating;

  Trainer({
    required this.id,
    required this.name,
    required this.role,
    required this.specializations,
    required this.commissionPercentage,
    required this.monthlySalary,
    required this.assignedMemberIds,
    required this.certifications,
    required this.joinDate,
    required this.avatarUrl,
    required this.email,
    required this.phone,
    required this.rating,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      specializations: List<String>.from(json['specializations']),
      commissionPercentage: json['commissionPercentage'],
      monthlySalary: (json['monthlySalary'] as num).toDouble(),
      assignedMemberIds: List<String>.from(json['assignedMemberIds']),
      certifications: List<String>.from(json['certifications']),
      joinDate: json['joinDate'],
      avatarUrl: json['avatarUrl'],
      email: json['email'],
      phone: json['phone'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
