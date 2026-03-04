class Member {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String membershipPlanId;
  final String joinDate;
  final String expiryDate;
  final bool isActive;
  final String? trainerId;
  final String avatarUrl;
  final double weight;
  final double height;
  final String goal;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.membershipPlanId,
    required this.joinDate,
    required this.expiryDate,
    required this.isActive,
    this.trainerId,
    required this.avatarUrl,
    required this.weight,
    required this.height,
    required this.goal,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      membershipPlanId: json['membershipPlanId'],
      joinDate: json['joinDate'],
      expiryDate: json['expiryDate'],
      isActive: json['isActive'],
      trainerId: json['trainerId'],
      avatarUrl: json['avatarUrl'],
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      goal: json['goal'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'membershipPlanId': membershipPlanId,
        'joinDate': joinDate,
        'expiryDate': expiryDate,
        'isActive': isActive,
        'trainerId': trainerId,
        'avatarUrl': avatarUrl,
        'weight': weight,
        'height': height,
        'goal': goal,
      };
}
