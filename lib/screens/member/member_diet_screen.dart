import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/diet_plan.dart';
import '../../models/nutrition_log.dart';

class MemberDietScreen extends StatelessWidget {
  const MemberDietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final nutrition = p.todaysNutritionLog;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Summary Card
          if (nutrition != null)
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Today's Summary",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('${nutrition.totalCalories} kcal consumed',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  _MacroRow(
                    protein: nutrition.totalProtein,
                    carbs: nutrition.totalCarbs,
                    fats: nutrition.totalFats,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          // Food Upload Banner
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FoodUploadScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.accentOrange.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.camera_alt_rounded,
                      color: AppTheme.accentOrange, size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Food Recognition',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        Text('Upload a meal photo to detect nutrition',
                            style: TextStyle(
                                color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white38, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Diet Plans',
            actionLabel: 'View All',
            onAction: () {},
          ),
          const SizedBox(height: 14),
          ...p.dietPlans.map((plan) => _DietPlanCard(plan: plan)),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final int protein;
  final int carbs;
  final int fats;

  const _MacroRow(
      {required this.protein, required this.carbs, required this.fats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MacroItem(label: 'Protein', value: '${protein}g', color: AppTheme.accentBlue),
        const SizedBox(width: 20),
        _MacroItem(label: 'Carbs', value: '${carbs}g', color: AppTheme.accentOrange),
        const SizedBox(width: 20),
        _MacroItem(label: 'Fats', value: '${fats}g', color: Colors.purple),
      ],
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w700, fontSize: 18)),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}

class _DietPlanCard extends StatelessWidget {
  final DietPlan plan;
  const _DietPlanCard({required this.plan});

  Color get _color {
    try {
      return Color(int.parse(plan.color.replaceFirst('#', 'FF'), radix: 16));
    } catch (_) {
      return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DietDetailScreen(plan: plan)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_color.withOpacity(0.15), AppTheme.darkCard],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.restaurant_menu_rounded,
                      color: _color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      Text(plan.goal,
                          style: TextStyle(
                              color: _color, fontSize: 12)),
                    ],
                  ),
                ),
                Text('${plan.calorieTarget} kcal',
                    style: TextStyle(
                        color: _color,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MacroChip(
                    label: '${plan.protein}g Protein',
                    color: AppTheme.accentBlue),
                const SizedBox(width: 8),
                _MacroChip(
                    label: '${plan.carbs}g Carbs',
                    color: AppTheme.accentOrange),
                const SizedBox(width: 8),
                _MacroChip(
                    label: '${plan.fats}g Fats', color: Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MacroChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      );
}

class DietDetailScreen extends StatelessWidget {
  final DietPlan plan;
  const DietDetailScreen({super.key, required this.plan});

  Color get _color {
    try {
      return Color(int.parse(plan.color.replaceFirst('#', 'FF'), radix: 16));
    } catch (_) {
      return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(plan.name,
              style: const TextStyle(fontWeight: FontWeight.w700))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Macro Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color.withOpacity(0.3), _color.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _color.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text('${plan.calorieTarget} kcal / day',
                      style: TextStyle(
                          color: _color,
                          fontWeight: FontWeight.w800,
                          fontSize: 26)),
                  Text(plan.goal,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MacroCircle(
                          label: 'Protein',
                          value: '${plan.protein}g',
                          color: AppTheme.accentBlue),
                      _MacroCircle(
                          label: 'Carbs',
                          value: '${plan.carbs}g',
                          color: AppTheme.accentOrange),
                      _MacroCircle(
                          label: 'Fats',
                          value: '${plan.fats}g',
                          color: Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(plan.description,
                style: const TextStyle(
                    color: Colors.white70, height: 1.6, fontSize: 14)),
            const SizedBox(height: 24),
            const Text('Meal Plan',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 14),
            ...plan.meals.map((meal) => _MealCard(meal: meal, color: _color)),
          ],
        ),
      ),
    );
  }
}

class _MacroCircle extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroCircle(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.4), width: 2),
          ),
          child: Center(
            child: Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14)),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealItem meal;
  final Color color;
  const _MealCard({required this.meal, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(meal.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${meal.calories} kcal',
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(meal.time,
              style:
                  const TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 10),
          ...meal.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: color, size: 6),
                    const SizedBox(width: 8),
                    Text(item,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ---- Food Upload Screen ----
class FoodUploadScreen extends StatefulWidget {
  const FoodUploadScreen({super.key});

  @override
  State<FoodUploadScreen> createState() => _FoodUploadScreenState();
}

class _FoodUploadScreenState extends State<FoodUploadScreen> {
  bool _analyzed = false;

  final _mockResults = [
    {
      'food': 'Grilled Chicken Breast',
      'calories': 165,
      'protein': 31,
      'carbs': 0,
      'fats': 3
    },
    {
      'food': 'Brown Rice (100g)',
      'calories': 112,
      'protein': 3,
      'carbs': 24,
      'fats': 1
    },
    {
      'food': 'Steamed Broccoli',
      'calories': 35,
      'protein': 2,
      'carbs': 7,
      'fats': 0
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('AI Food Recognition',
              style: TextStyle(fontWeight: FontWeight.w700))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Upload Area
            GestureDetector(
              onTap: () => setState(() => _analyzed = true),
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accentOrange.withOpacity(0.2),
                      AppTheme.accentOrange.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accentOrange.withOpacity(0.4),
                    width: 2,
                    // dashed effect via strokeWidth
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _analyzed
                          ? Icons.check_circle_rounded
                          : Icons.camera_alt_rounded,
                      color: AppTheme.accentOrange,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _analyzed
                          ? 'Photo Analyzed!'
                          : 'Tap to upload meal photo',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    const Text('AI will detect food and estimate nutrition',
                        style: TextStyle(
                            color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),
            ),
            if (_analyzed) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.accentGreen.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        color: AppTheme.accentGreen),
                    SizedBox(width: 8),
                    Text('AI detected 3 food items',
                        style: TextStyle(
                            color: AppTheme.accentGreen,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ..._mockResults.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.darkBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.restaurant_rounded,
                            color: AppTheme.accentOrange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r['food'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                'P: ${r['protein']}g • C: ${r['carbs']}g • F: ${r['fats']}g',
                                style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text('${r['calories']} kcal',
                            style: const TextStyle(
                                color: AppTheme.accentOrange,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final p = context.read<AppProvider>();
                    for (final r in _mockResults) {
                      p.addFoodEntry(
                        NutritionEntry(
                          food: r['food'] as String,
                          calories: r['calories'] as int,
                          protein: r['protein'] as int,
                          carbs: r['carbs'] as int,
                          fats: r['fats'] as int,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add to Today\'s Log'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
