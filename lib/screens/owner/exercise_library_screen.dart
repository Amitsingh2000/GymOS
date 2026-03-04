import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/exercise.dart';
import '../shared/exercise_detail_screen.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  String _filter = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final muscleGroups = [
      'All',
      'Chest',
      'Back',
      'Legs',
      'Shoulders',
      'Core',
      'Cardio'
    ];
    final filtered = p.exercises.where((e) {
      final matchQuery = _searchQuery.isEmpty ||
          e.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchFilter = _filter == 'All' ||
          e.muscleGroups
              .any((m) => m.toLowerCase().contains(_filter.toLowerCase()));
      return matchQuery && matchFilter;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: muscleGroups.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final m = muscleGroups[i];
                final sel = m == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = m),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: sel ? AppTheme.primaryColor : AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel ? AppTheme.primaryColor : AppTheme.darkBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(m,
                          style: TextStyle(
                            color: sel ? Colors.white : Colors.white60,
                            fontSize: 13,
                            fontWeight: sel
                                ? FontWeight.w600
                                : FontWeight.normal,
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.sports_gymnastics_rounded,
                    message: 'No exercises found')
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _ExerciseCard(exercise: filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Exercise'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddExerciseSheet(),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final difficulty = exercise.difficulty;
    final color = AppTheme.difficultyColor(difficulty);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(exercise: exercise),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sports_gymnastics_rounded,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    exercise.muscleGroups.join(' • '),
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TagChip(label: difficulty, color: color),
                      const SizedBox(width: 6),
                      TagChip(
                          label: '${exercise.suggestedSets}x${exercise.suggestedReps}',
                          color: AppTheme.accentBlue),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

class _AddExerciseSheet extends StatefulWidget {
  const _AddExerciseSheet();

  @override
  State<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<_AddExerciseSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _difficulty = 'Beginner';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Exercise',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Exercise Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descCtrl,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _difficulty,
            decoration: const InputDecoration(labelText: 'Difficulty'),
            dropdownColor: AppTheme.darkCard,
            items: ['Beginner', 'Intermediate', 'Advanced']
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => _difficulty = v ?? _difficulty),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Save Exercise'),
            ),
          ),
        ],
      ),
    );
  }
}
