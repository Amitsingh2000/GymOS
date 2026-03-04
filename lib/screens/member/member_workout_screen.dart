import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../shared/exercise_detail_screen.dart';
import 'member_workout_builder_screen.dart';

class MemberWorkoutScreen extends StatelessWidget {
  const MemberWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final plans = p.currentMemberWorkoutPlans;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Browse Equipment Banner
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF283593)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const _BrowseEquipmentScreen()),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Browse Equipment',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('Explore Gym Equipment',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  Icon(Icons.fitness_center_rounded,
                      color: Colors.white54, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'My Workout Plans',
              actionLabel: '+ New Plan',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const MemberWorkoutBuilderScreen()),
              ),
            ),
            const SizedBox(height: 14),
            if (plans.isEmpty)
              const EmptyStateWidget(
                icon: Icons.fitness_center_rounded,
                message: 'No workout plans yet.\nCreate your first plan!',
              )
            else
              ...plans.map((plan) => _WorkoutPlanCard(plan: plan)),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Exercise Library'),
            const SizedBox(height: 14),
            ...p.exercises.map((e) => Container(
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
                    subtitle: Text(e.difficulty,
                        style: TextStyle(
                            color: AppTheme.difficultyColor(e.difficulty),
                            fontSize: 12)),
                    trailing: const Icon(Icons.play_circle_rounded,
                        color: AppTheme.primaryColor),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ExerciseDetailScreen(exercise: e)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _WorkoutPlanCard extends StatelessWidget {
  final dynamic plan;
  const _WorkoutPlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.statusColor(plan.status).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${plan.days.length} training days',
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),
              StatusBadge(status: plan.status),
            ],
          ),
          if (plan.trainerFeedback != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('💬 ${plan.trainerFeedback}',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12)),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: (plan.days as List)
                .map((d) =>
                    TagChip(label: d.day, color: AppTheme.accentBlue))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BrowseEquipmentScreen extends StatelessWidget {
  const _BrowseEquipmentScreen();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Gym Equipment',
              style: TextStyle(fontWeight: FontWeight.w700))),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: p.equipment.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final eq = p.equipment[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.darkBorder),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(eq.imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                            width: 70,
                            height: 70,
                            color: AppTheme.darkBorder,
                            child: const Icon(Icons.fitness_center_rounded,
                                color: Colors.white24),
                          )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(eq.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      Text('${eq.brand} • ${eq.category}',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 12)),
                      const SizedBox(height: 6),
                      TagChip(
                          label: eq.condition,
                          color:
                              AppTheme.conditionColor(eq.condition)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
