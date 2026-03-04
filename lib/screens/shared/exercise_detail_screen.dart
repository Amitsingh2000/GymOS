import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/exercise.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    _ytController = YoutubePlayerController(
      initialVideoId: widget.exercise.videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _ytController),
      builder: (context, player) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                snap: true,
                title: Text(e.name,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // YouTube Player
                    Container(
                      decoration: const BoxDecoration(color: Colors.black),
                      child: player,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              TagChip(
                                  label: e.difficulty,
                                  color:
                                      AppTheme.difficultyColor(e.difficulty)),
                              TagChip(
                                  label: e.equipmentName,
                                  color: AppTheme.accentBlue),
                              ...e.tags.map((t) =>
                                  TagChip(label: t, color: Colors.white54)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Stats Row
                          Row(
                            children: [
                              _StatBox(
                                  icon: Icons.replay_rounded,
                                  label: '${e.suggestedSets} Sets',
                                  color: AppTheme.primaryColor),
                              const SizedBox(width: 10),
                              _StatBox(
                                  icon: Icons.fitness_center_rounded,
                                  label: '${e.suggestedReps} Reps',
                                  color: AppTheme.accentGreen),
                              const SizedBox(width: 10),
                              _StatBox(
                                  icon: Icons.timer_rounded,
                                  label:
                                      '${e.restTime}s Rest',
                                  color: AppTheme.accentOrange),
                              const SizedBox(width: 10),
                              _StatBox(
                                  icon: Icons.local_fire_department_rounded,
                                  label: '${e.calories} kcal',
                                  color: Colors.red),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text('Target Muscles',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: e.muscleGroups
                                .map((m) => TagChip(
                                    label: m, color: AppTheme.primaryColor))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text('Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(e.description,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.6,
                                  fontSize: 14)),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.add_rounded),
                              label:
                                  const Text('Add to Workout Plan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatBox(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
