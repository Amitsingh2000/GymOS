class MembershipPlan {
  final String id;
  final String name;
  final String tier;
  final double monthlyPrice;
  final int durationMonths;
  final String color;
  final List<String> includedServices;
  final List<String> excludedServices;
  final int maxFreezes;
  final int guestPasses;
  final bool active;

  MembershipPlan({
    required this.id,
    required this.name,
    required this.tier,
    required this.monthlyPrice,
    required this.durationMonths,
    required this.color,
    required this.includedServices,
    required this.excludedServices,
    required this.maxFreezes,
    required this.guestPasses,
    required this.active,
  });

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id'],
      name: json['name'],
      tier: json['tier'],
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      durationMonths: json['durationMonths'],
      color: json['color'],
      includedServices: List<String>.from(json['includedServices']),
      excludedServices: List<String>.from(json['excludedServices']),
      maxFreezes: json['maxFreezes'],
      guestPasses: json['guestPasses'],
      active: json['active'],
    );
  }
}
