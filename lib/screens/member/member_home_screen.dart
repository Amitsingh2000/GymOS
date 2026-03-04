import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../shared/exercise_detail_screen.dart';
import 'member_workout_builder_screen.dart';

class MemberHomeScreen extends StatelessWidget {
  const MemberHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    if (p.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final member = p.currentMember;
    if (member == null) return const SizedBox();
    final plan = p.planForMember(member);
    final trainer = p.trainerForMember(member);
    final nutrition = p.todaysNutritionLog;
    final workoutPlans = p.currentMemberWorkoutPlans;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Welcome Card
          GradientCard(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00BCD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(member.name.split(' ').first + ' 💪',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('Goal: ${member.goal}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13)),
                      if (plan != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(plan.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(member.avatarUrl),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (nutrition != null) ...[
            const SectionHeader(title: "Today's Nutrition"),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.darkBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${nutrition.totalCalories} kcal',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20)),
                      const Text('Today',
                          style: TextStyle(color: Colors.white60)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MacroBar(
                      label: 'Protein',
                      current: nutrition.totalProtein,
                      goal: 160,
                      color: AppTheme.accentBlue),
                  const SizedBox(height: 10),
                  MacroBar(
                      label: 'Carbs',
                      current: nutrition.totalCarbs,
                      goal: 250,
                      color: AppTheme.accentOrange),
                  const SizedBox(height: 10),
                  MacroBar(
                      label: 'Fats',
                      current: nutrition.totalFats,
                      goal: 70,
                      color: Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Quick Actions
          const SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.add_rounded,
                  label: 'New Workout',
                  color: AppTheme.primaryColor,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const MemberWorkoutBuilderScreen())),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickAction(
                  icon: Icons.camera_alt_rounded,
                  label: 'AI Form Check',
                  color: AppTheme.accentOrange,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const AIFormValidationScreen())),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // My Plans
          const SectionHeader(title: 'My Workout Plans'),
          const SizedBox(height: 14),
          if (workoutPlans.isEmpty)
            const EmptyStateWidget(
                icon: Icons.fitness_center_rounded,
                message: 'No workout plans yet.\nCreate your first one!')
          else
            ...workoutPlans.take(3).map((plan) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.darkBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            Text('${plan.days.length} training days',
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ),
                      StatusBadge(status: plan.status),
                    ],
                  ),
                )),

          if (trainer != null) ...[
            const SizedBox(height: 24),
            const SectionHeader(title: 'My Trainer'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.darkBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(trainer.avatarUrl),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trainer.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                        Text(trainer.role,
                            style: TextStyle(
                                color: AppTheme.primaryColor, fontSize: 13)),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 14),
                            const SizedBox(width: 3),
                            Text(trainer.rating.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.message_rounded,
                        color: AppTheme.primaryColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          const SectionHeader(title: 'Featured Exercises'),
          const SizedBox(height: 14),
          ...p.exercises.take(3).map((e) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.darkBorder),
                ),
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.sports_gymnastics_rounded,
                        color: Colors.white, size: 22),
                  ),
                  title: Text(e.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(e.muscleGroups.join(' • '),
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 11)),
                  trailing: const Icon(Icons.play_circle_rounded,
                      color: AppTheme.primaryColor),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseDetailScreen(exercise: e),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class AIFormValidationScreen extends StatelessWidget {
  const AIFormValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('AI Form Validation',
              style: TextStyle(fontWeight: FontWeight.w700))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_rounded, color: Colors.white, size: 64),
                  SizedBox(height: 12),
                  Text('Camera',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppTheme.accentGreen.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      color: AppTheme.accentGreen, size: 18),
                  SizedBox(width: 8),
                  Text('AI posture detection running...',
                      style: TextStyle(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Position yourself in camera view\nand perform your exercise.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
