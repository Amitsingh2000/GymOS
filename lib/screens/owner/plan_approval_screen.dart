import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class PlanApprovalScreen extends StatelessWidget {
  const PlanApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final allPlans = p.workoutPlans;

    if (allPlans.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Plan Approvals')),
        body: const EmptyStateWidget(
          icon: Icons.pending_actions_rounded,
          message: 'No submitted plans yet.',
        ),
      );
    }

    final pending = allPlans.where((pl) => pl.status == 'pending').toList();
    final reviewed = allPlans.where((pl) => pl.status != 'pending').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Approvals',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (pending.isNotEmpty) ...[
            const SectionHeader(title: 'Pending Review'),
            const SizedBox(height: 12),
            ...pending.map((plan) {
              final member = p.members.firstWhere(
                (m) => m.id == plan.memberId,
                orElse: () => p.members.first,
              );
              return _PlanReviewCard(plan: plan, memberName: member.name,
                  memberAvatar: member.avatarUrl);
            }),
            const SizedBox(height: 24),
          ],
          if (reviewed.isNotEmpty) ...[
            const SectionHeader(title: 'Reviewed Plans'),
            const SizedBox(height: 12),
            ...reviewed.map((plan) {
              final member = p.members.firstWhere(
                (m) => m.id == plan.memberId,
                orElse: () => p.members.first,
              );
              return _PlanReviewCard(plan: plan, memberName: member.name,
                  memberAvatar: member.avatarUrl);
            }),
          ],
        ],
      ),
    );
  }
}

class _PlanReviewCard extends StatelessWidget {
  final dynamic plan;
  final String memberName;
  final String memberAvatar;

  const _PlanReviewCard({
    required this.plan,
    required this.memberName,
    required this.memberAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(memberAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    Text(memberName,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),
              StatusBadge(status: plan.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${plan.days.length} training days • Submitted: ${plan.submittedDate}',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          if (plan.trainerFeedback != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.darkBorder.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '💬 ${plan.trainerFeedback}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
          if (plan.status == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showReviewDialog(context, plan, 'rejected'),
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showReviewDialog(context, plan, 'approved'),
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showReviewDialog(
      BuildContext context, dynamic plan, String status) {
    final feedbackCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: Text(status == 'approved' ? '✅ Approve Plan' : '❌ Reject Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status == 'approved'
                  ? 'Add an optional note for the member:'
                  : 'Provide feedback for the member:',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: feedbackCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: status == 'approved'
                    ? 'Great plan! Keep it up...'
                    : 'Please revise...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AppProvider>().reviewWorkoutPlan(
                    plan.id,
                    status,
                    feedbackCtrl.text.isEmpty ? null : feedbackCtrl.text,
                  );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'approved'
                  ? AppTheme.accentGreen
                  : Colors.red,
            ),
            child: Text(status == 'approved' ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );
  }
}
