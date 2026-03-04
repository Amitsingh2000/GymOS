import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'plan_approval_screen.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    if (p.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final revenue = p.monthlyRevenue;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
          GradientCard(
            gradient: AppTheme.primaryGradient,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Good Morning,',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'GymOS Owner 👋',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${p.pendingWorkoutPlans.length} plan(s) awaiting review',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PlanApprovalScreen(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${p.pendingWorkoutPlans.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.pending_actions_rounded,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Analytics Overview'),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              StatCard(
                title: 'Total Members',
                value: '${p.members.length}',
                icon: Icons.people_rounded,
                color: AppTheme.primaryColor,
              ),
              StatCard(
                title: 'Active Members',
                value: '${p.activeMembers}',
                icon: Icons.person_pin_rounded,
                color: AppTheme.accentGreen,
                subtitle: 'Active',
              ),
              StatCard(
                title: 'Monthly Revenue',
                value: '\$${revenue.toStringAsFixed(0)}',
                icon: Icons.attach_money_rounded,
                color: AppTheme.accentOrange,
              ),
              StatCard(
                title: 'Trainers',
                value: '${p.trainers.length}',
                icon: Icons.sports_rounded,
                color: AppTheme.accentBlue,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Member Activity'),
          const SizedBox(height: 14),
          _ActivityChart(),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Equipment by Category'),
          const SizedBox(height: 14),
          _EquipmentPieChart(p: p),
          const SizedBox(height: 24),
          Row(
            children: [
              const SectionHeader(title: 'Pending Approvals'),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          ...p.pendingWorkoutPlans.take(3).map((plan) {
            final member = p.members.firstWhere(
              (m) => m.id == plan.memberId,
              orElse: () => p.members.first,
            );
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(member.avatarUrl),
                ),
                title: Text(plan.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(member.name,
                    style: const TextStyle(color: Colors.white60)),
                trailing: const StatusBadge(status: 'pending'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlanApprovalScreen(),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ActivityChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monthLabels = ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'];
    final values = [22.0, 28.0, 25.0, 18.0, 32.0, 30.0];
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 40,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: AppTheme.darkBorder, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) => Text(
                  monthLabels[v.toInt().clamp(0, 5)],
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                interval: 1,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                  6, (i) => FlSpot(i.toDouble(), values[i])),
              isCurved: true,
              gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor]),
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.3),
                    AppTheme.primaryColor.withOpacity(0),
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

class _EquipmentPieChart extends StatelessWidget {
  final AppProvider p;
  const _EquipmentPieChart({required this.p});

  @override
  Widget build(BuildContext context) {
    final categories = <String, int>{};
    for (final eq in p.equipment) {
      categories[eq.category] = (categories[eq.category] ?? 0) + 1;
    }
    final colors = [
      AppTheme.primaryColor,
      AppTheme.accentGreen,
      AppTheme.accentOrange,
      AppTheme.accentBlue,
      const Color(0xFFE91E63),
    ];
    final entries = categories.entries.toList();
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: List.generate(entries.length, (i) {
                  final e = entries[i];
                  return PieChartSectionData(
                    value: e.value.toDouble(),
                    color: colors[i % colors.length],
                    title: '${e.value}',
                    radius: 55,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  );
                }),
                sectionsSpace: 3,
                centerSpaceRadius: 25,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(entries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      entries[i].key,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
