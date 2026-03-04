import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_provider.dart';
import '../../models/progress_record.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class MemberProgressScreen extends StatelessWidget {
  const MemberProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final record = p.currentMemberProgress;
    final entries = record?.entries ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressHeroBanner(entries: entries),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Weight Progress',
            actionLabel: '+ Log',
            onAction: () => _showLogSheet(context),
          ),
          const SizedBox(height: 14),
          _WeightChart(entries: entries),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Latest Measurements'),
          const SizedBox(height: 14),
          if (entries.isNotEmpty) _MeasurementsCard(entry: entries.last),
          const SizedBox(height: 24),
          const SectionHeader(title: 'History'),
          const SizedBox(height: 14),
          if (entries.isEmpty)
            const EmptyStateWidget(
              icon: Icons.timeline_rounded,
              message: 'No progress recorded yet.\nTap "+ Log" to add your first entry!',
            )
          else
            ...entries.reversed.take(10).map((e) => _HistoryEntry(entry: e)),
        ],
      ),
    );
  }

  void _showLogSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<AppProvider>(),
        child: const _LogSheet(),
      ),
    );
  }
}

class _ProgressHeroBanner extends StatelessWidget {
  final List<ProgressEntry> entries;
  const _ProgressHeroBanner({required this.entries});

  @override
  Widget build(BuildContext context) {
    final latest = entries.isNotEmpty ? entries.last : null;
    final first = entries.isNotEmpty ? entries.first : null;
    final weightChange = (latest != null && first != null && entries.length > 1)
        ? latest.weight - first.weight
        : 0.0;

    return GradientCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progress Overview',
              style: TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _HeroStat(
                label: 'Current Weight',
                value: latest != null ? '${latest.weight}kg' : '--',
                icon: Icons.monitor_weight_rounded,
                color: Colors.white,
              ),
              Container(width: 1, height: 50, color: Colors.white24),
              _HeroStat(
                label: 'Change',
                value: weightChange == 0
                    ? '--'
                    : '${weightChange > 0 ? '+' : ''}${weightChange.toStringAsFixed(1)}kg',
                icon: weightChange < 0
                    ? Icons.trending_down_rounded
                    : Icons.trending_up_rounded,
                color: weightChange < 0 ? AppTheme.accentGreen : AppTheme.accentOrange,
              ),
              Container(width: 1, height: 50, color: Colors.white24),
              _HeroStat(
                label: 'Entries',
                value: '${entries.length}',
                icon: Icons.bar_chart_rounded,
                color: AppTheme.accentBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _HeroStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 20)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}

class _WeightChart extends StatelessWidget {
  final List<ProgressEntry> entries;
  const _WeightChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.length < 2) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: const Center(
          child: Text('Add at least 2 entries to see chart',
              style: TextStyle(color: Colors.white38)),
        ),
      );
    }

    final spots = entries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();

    final minY = entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 2;
    final maxY = entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 2;

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: AppTheme.darkBorder, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 5,
                getTitlesWidget: (v, _) => Text(
                  '${v.toStringAsFixed(0)}kg',
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: entries.length > 6 ? (entries.length / 4).floorToDouble() : 1,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= entries.length) return const SizedBox();
                  final parts = entries[idx].date.split('-');
                  return Text(
                    parts.length >= 3 ? '${parts[2]}/${parts[1]}' : '',
                    style: const TextStyle(color: Colors.white38, fontSize: 9),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(
                  colors: [AppTheme.accentBlue, AppTheme.primaryColor]),
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.accentBlue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentBlue.withOpacity(0.25),
                    AppTheme.accentBlue.withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementsCard extends StatelessWidget {
  final ProgressEntry entry;
  const _MeasurementsCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Chest', '${entry.chest} cm', AppTheme.accentOrange),
      ('Waist', '${entry.waist} cm', AppTheme.primaryColor),
      ('Hips', '${entry.hips} cm', const Color(0xFF9C27B0)),
      ('Arms', '${entry.arms} cm', AppTheme.accentGreen),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: items.map((item) {
        final color = item.$3;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.$2,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w800, fontSize: 18)),
              Text(item.$1,
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _HistoryEntry extends StatelessWidget {
  final ProgressEntry entry;
  const _HistoryEntry({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.monitor_weight_rounded,
                color: AppTheme.accentBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${entry.weight}kg',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Text(entry.date,
                    style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('C:${entry.chest} W:${entry.waist}',
                  style: const TextStyle(color: Colors.white60, fontSize: 11)),
              Text('H:${entry.hips} A:${entry.arms}',
                  style: const TextStyle(color: Colors.white60, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogSheet extends StatefulWidget {
  const _LogSheet();

  @override
  State<_LogSheet> createState() => _LogSheetState();
}

class _LogSheetState extends State<_LogSheet> {
  final _weightCtrl = TextEditingController(text: '75.0');
  final _chestCtrl = TextEditingController(text: '95');
  final _waistCtrl = TextEditingController(text: '80');
  final _hipsCtrl = TextEditingController(text: '90');
  final _armsCtrl = TextEditingController(text: '35');
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _weightCtrl.dispose();
    _chestCtrl.dispose();
    _waistCtrl.dispose();
    _hipsCtrl.dispose();
    _armsCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final p = context.read<AppProvider>();
    p.addProgressEntry(ProgressEntry(
      date: DateTime.now().toIso8601String().substring(0, 10),
      weight: double.tryParse(_weightCtrl.text) ?? 75.0,
      chest: int.tryParse(_chestCtrl.text) ?? 95,
      waist: int.tryParse(_waistCtrl.text) ?? 80,
      hips: int.tryParse(_hipsCtrl.text) ?? 90,
      arms: int.tryParse(_armsCtrl.text) ?? 35,
      notes: _notesCtrl.text.trim(),
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Progress logged!'),
        backgroundColor: AppTheme.accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Log Measurement',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          const SizedBox(height: 4),
          Text(DateTime.now().toIso8601String().substring(0, 10),
              style: const TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 20),
          TextField(
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              prefixIcon: Icon(Icons.monitor_weight_rounded),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chestCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Chest (cm)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _waistCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Waist (cm)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hipsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Hips (cm)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _armsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Arms (cm)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Entry',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
