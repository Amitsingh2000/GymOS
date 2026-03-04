import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/workout_plan.dart';
import '../../models/exercise.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class MemberWorkoutBuilderScreen extends StatefulWidget {
  const MemberWorkoutBuilderScreen({super.key});

  @override
  State<MemberWorkoutBuilderScreen> createState() =>
      _MemberWorkoutBuilderScreenState();
}

class _MemberWorkoutBuilderScreenState
    extends State<MemberWorkoutBuilderScreen> {
  final _nameController = TextEditingController();
  final List<_BuilderDay> _days = [];
  int _step = 0; // 0 = name, 1 = add days, 2 = review

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a plan name')),
      );
      return;
    }
    if (_step < 2) setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  void _addDay() {
    setState(() {
      _days.add(_BuilderDay(
        dayController: TextEditingController(text: 'Day ${_days.length + 1}'),
        focusController: TextEditingController(text: 'Full Body'),
        exercises: [],
      ));
    });
  }

  void _removeDay(int index) {
    setState(() {
      _days[index].dayController.dispose();
      _days[index].focusController.dispose();
      _days.removeAt(index);
    });
  }

  Future<void> _pickExercise(int dayIndex) async {
    final p = context.read<AppProvider>();
    final exercise = await showModalBottomSheet<Exercise>(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ExercisePickerSheet(exercises: p.exercises),
    );
    if (exercise != null) {
      setState(() {
        _days[dayIndex].exercises.add(_BuilderExercise(
          exercise: exercise,
          setsController: TextEditingController(text: '3'),
          repsController: TextEditingController(text: '10'),
          restController: TextEditingController(text: '60'),
        ));
      });
    }
  }

  void _submit() {
    final p = context.read<AppProvider>();
    final plan = WorkoutPlan(
      id: 'wp_${DateTime.now().millisecondsSinceEpoch}',
      memberId: p.currentMemberId,
      name: _nameController.text.trim(),
      status: 'pending',
      submittedDate: DateTime.now().toIso8601String().substring(0, 10),
      days: _days.map((d) {
        return WorkoutDay(
          day: d.dayController.text.trim(),
          focus: d.focusController.text.trim(),
          exercises: d.exercises.map((e) {
            return WorkoutExercise(
              exerciseId: e.exercise.id,
              sets: int.tryParse(e.setsController.text) ?? 3,
              reps: e.repsController.text.trim(),
              rest: int.tryParse(e.restController.text) ?? 60,
            );
          }).toList(),
        );
      }).toList(),
    );
    p.submitWorkoutPlan(plan);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Plan submitted for trainer approval!'),
        backgroundColor: AppTheme.accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Workout Plan',
            style: TextStyle(fontWeight: FontWeight.w700)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (_step + 1) / 3,
                backgroundColor: AppTheme.darkBorder,
                valueColor:
                    const AlwaysStoppedAnimation(AppTheme.primaryColor),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStep(),
              ),
            ),
            _buildNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _StepName(controller: _nameController);
      case 1:
        return _StepDays(
          days: _days,
          onAddDay: _addDay,
          onRemoveDay: _removeDay,
          onPickExercise: _pickExercise,
          onRefresh: () => setState(() {}),
        );
      case 2:
        return _StepReview(
            name: _nameController.text.trim(), days: _days);
      default:
        return const SizedBox();
    }
  }

  Widget _buildNavBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        border: Border(top: BorderSide(color: AppTheme.darkBorder)),
      ),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.darkBorder),
                  foregroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_step > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _step == 2 ? _submit : _nextStep,
              child: Text(_step == 2 ? '🚀 Submit for Approval' : 'Continue',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 0: Plan Name ────────────────────────────────────────────────────────

class _StepName extends StatelessWidget {
  final TextEditingController controller;
  const _StepName({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        GradientCard(
          gradient: AppTheme.primaryGradient,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.fitness_center_rounded,
                  color: Colors.white70, size: 32),
              SizedBox(height: 12),
              Text('Step 1 of 3',
                  style: TextStyle(color: Colors.white60, fontSize: 13)),
              SizedBox(height: 4),
              Text('Name Your Plan',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              SizedBox(height: 6),
              Text('Give your workout plan a memorable name.',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text('Plan Name',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          decoration: const InputDecoration(
            hintText: 'e.g. Summer Shred Plan',
            prefixIcon: Icon(Icons.edit_rounded, color: AppTheme.primaryColor),
          ),
        ),
        const SizedBox(height: 20),
        _SuggestionChips(controller: controller),
      ],
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  final TextEditingController controller;
  const _SuggestionChips({required this.controller});

  static const _suggestions = [
    'Summer Shred',
    'Muscle Builder',
    'Strength Program',
    'Fat Loss Plan',
    'Beginner Routine',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Suggestions:',
            style: TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestions
              .map((s) => GestureDetector(
                    onTap: () => controller.text = s,
                    child: TagChip(label: s, color: AppTheme.primaryColor),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─── Step 1: Add Days ─────────────────────────────────────────────────────────

class _BuilderExercise {
  final Exercise exercise;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController restController;

  _BuilderExercise({
    required this.exercise,
    required this.setsController,
    required this.repsController,
    required this.restController,
  });
}

class _BuilderDay {
  final TextEditingController dayController;
  final TextEditingController focusController;
  final List<_BuilderExercise> exercises;

  _BuilderDay({
    required this.dayController,
    required this.focusController,
    required this.exercises,
  });
}

class _StepDays extends StatelessWidget {
  final List<_BuilderDay> days;
  final VoidCallback onAddDay;
  final void Function(int) onRemoveDay;
  final Future<void> Function(int) onPickExercise;
  final VoidCallback onRefresh;

  const _StepDays({
    required this.days,
    required this.onAddDay,
    required this.onRemoveDay,
    required this.onPickExercise,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Step 2 of 3',
                      style: TextStyle(color: Colors.white60, fontSize: 12)),
                  const Text('Add Training Days',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 20)),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: onAddDay,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Day'),
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (days.isEmpty)
          const EmptyStateWidget(
            icon: Icons.calendar_today_rounded,
            message: 'No training days yet.\nTap "Add Day" to get started!',
          )
        else
          ...List.generate(days.length, (i) => _DayCard(
                dayIndex: i,
                day: days[i],
                onRemove: () => onRemoveDay(i),
                onPickExercise: () => onPickExercise(i),
                onRefresh: onRefresh,
              )),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final int dayIndex;
  final _BuilderDay day;
  final VoidCallback onRemove;
  final VoidCallback onPickExercise;
  final VoidCallback onRefresh;

  const _DayCard({
    required this.dayIndex,
    required this.day,
    required this.onRemove,
    required this.onPickExercise,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('${dayIndex + 1}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: day.dayController,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Day label',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: 20),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: day.focusController,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Focus (e.g. Chest & Triceps)',
              prefixIcon: Icon(Icons.sports_gymnastics_rounded,
                  color: Colors.white30, size: 16),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
          if (day.exercises.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            ...day.exercises.asMap().entries.map((e) => _ExerciseRow(
                  entry: e.value,
                  onRemove: () {
                    day.exercises.removeAt(e.key);
                    onRefresh();
                  },
                )),
          ],
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onPickExercise,
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppTheme.accentBlue, size: 18),
            label: const Text('Add Exercise',
                style: TextStyle(color: AppTheme.accentBlue)),
          ),
        ],
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  final _BuilderExercise entry;
  final VoidCallback onRemove;

  const _ExerciseRow({required this.entry, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.darkBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.sports_gymnastics_rounded,
                    color: AppTheme.primaryColor, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(entry.exercise.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: Colors.white38, size: 16),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _MiniField(label: 'Sets', controller: entry.setsController),
              const SizedBox(width: 10),
              _MiniField(label: 'Reps', controller: entry.repsController),
              const SizedBox(width: 10),
              _MiniField(
                  label: 'Rest (s)', controller: entry.restController),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _MiniField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(color: Colors.white38, fontSize: 10)),
          const SizedBox(height: 2),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 2: Review ───────────────────────────────────────────────────────────

class _StepReview extends StatelessWidget {
  final String name;
  final List<_BuilderDay> days;

  const _StepReview({required this.name, required this.days});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        GradientCard(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white70, size: 28),
                  SizedBox(width: 10),
                  Text('Step 3 of 3: Review',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Text(name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('${days.length} training day${days.length == 1 ? '' : 's'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (days.isEmpty)
          const EmptyStateWidget(
            icon: Icons.warning_amber_rounded,
            message: 'No training days added.\nGo back and add at least one.',
          )
        else
          ...days.asMap().entries.map((e) {
            final d = e.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
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
                      TagChip(
                          label: d.dayController.text,
                          color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(d.focusController.text,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 13)),
                    ],
                  ),
                  if (d.exercises.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ...d.exercises.map((ex) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.circle,
                                  color: AppTheme.primaryColor, size: 6),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(ex.exercise.name,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13)),
                              ),
                              Text(
                                  '${ex.setsController.text}×${ex.repsController.text}',
                                  style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12)),
                            ],
                          ),
                        )),
                  ] else
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('No exercises added',
                          style: TextStyle(
                              color: Colors.white30, fontSize: 12)),
                    ),
                ],
              ),
            );
          }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentOrange.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.accentOrange.withOpacity(0.2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppTheme.accentOrange, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your plan will be submitted for trainer review. You\'ll be notified once approved.',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Exercise Picker Bottom Sheet ─────────────────────────────────────────────

class _ExercisePickerSheet extends StatefulWidget {
  final List<Exercise> exercises;
  const _ExercisePickerSheet({required this.exercises});

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.exercises
        .where((e) =>
            e.name.toLowerCase().contains(_query.toLowerCase()) ||
            e.muscleGroups.any(
                (m) => m.toLowerCase().contains(_query.toLowerCase())))
        .toList();

    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.sports_gymnastics_rounded,
                  color: AppTheme.primaryColor),
              SizedBox(width: 10),
              Text('Pick an Exercise',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 17)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final e = filtered[i];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                tileColor: AppTheme.darkCard,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.sports_gymnastics_rounded,
                      color: Colors.white, size: 18),
                ),
                title: Text(e.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text(e.muscleGroups.join(' • '),
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 11)),
                trailing: TagChip(
                    label: e.difficulty,
                    color:
                        AppTheme.difficultyColor(e.difficulty)),
                onTap: () => Navigator.pop(context, e),
              );
            },
          ),
        ),
      ],
    );
  }
}
