import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../models/membership_plan.dart';

class MembershipPlansScreen extends StatelessWidget {
  const MembershipPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    return Scaffold(
      body: p.membershipPlans.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: p.membershipPlans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _PlanCard(plan: p.membershipPlans[i]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPlanSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Plan'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showAddPlanSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddPlanSheet(),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final MembershipPlan plan;
  const _PlanCard({required this.plan});

  Color get _planColor {
    try {
      return Color(int.parse(plan.color.replaceFirst('#', 'FF'), radix: 16));
    } catch (_) {
      return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_planColor.withOpacity(0.2), AppTheme.darkCard],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _planColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.tier.toUpperCase(),
                        style: TextStyle(
                            color: _planColor,
                            fontSize: 12,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(plan.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${plan.monthlyPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: _planColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 24),
                    ),
                    const Text('/month',
                        style:
                            TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: _planColor.withOpacity(0.2)),
            const SizedBox(height: 12),
            ...plan.includedServices.take(4).map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: _planColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(s,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ),
                    ],
                  ),
                )),
            if (plan.includedServices.length > 4)
              Text('+${plan.includedServices.length - 4} more',
                  style: TextStyle(color: _planColor, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoBadge(
                    label: '${plan.maxFreezes} Freezes',
                    icon: Icons.ac_unit_rounded,
                    color: AppTheme.accentBlue),
                const SizedBox(width: 8),
                _InfoBadge(
                    label: '${plan.guestPasses} Guest Passes',
                    icon: Icons.group_rounded,
                    color: AppTheme.accentGreen),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _planColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _planColor.withOpacity(0.3)),
                  ),
                  child: Text('Edit',
                      style: TextStyle(
                          color: _planColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _InfoBadge(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _AddPlanSheet extends StatefulWidget {
  const _AddPlanSheet();

  @override
  State<_AddPlanSheet> createState() => _AddPlanSheetState();
}

class _AddPlanSheetState extends State<_AddPlanSheet> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _tier = 'Basic';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create Plan',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Plan Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Monthly Price (\$)',
                prefixText: '\$'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _tier,
            decoration: const InputDecoration(labelText: 'Tier'),
            dropdownColor: AppTheme.darkCard,
            items: ['Basic', 'Premium', 'Elite']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _tier = v ?? _tier),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Save Plan'),
            ),
          ),
        ],
      ),
    );
  }
}
