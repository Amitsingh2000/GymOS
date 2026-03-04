import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    if (p.trainers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: p.trainers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          final trainer = p.trainers[i];
          final members = p.members
              .where((m) => trainer.assignedMemberIds.contains(m.id))
              .toList();
          return _TrainerCard(trainer: trainer, assignedMembers: members);
        },
      ),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  final dynamic trainer;
  final List<dynamic> assignedMembers;

  const _TrainerCard({required this.trainer, required this.assignedMembers});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              TrainerDetailScreen(trainer: trainer, members: assignedMembers),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(trainer.avatarUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.darkCard, width: 2),
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trainer.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(trainer.role,
                      style: const TextStyle(
                          color: AppTheme.primaryColor, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (trainer.specializations as List<String>)
                        .take(2)
                        .map((s) =>
                            TagChip(label: s, color: AppTheme.accentBlue))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatBadge(
                          label:
                              '${trainer.commissionPercentage}% Commission',
                          icon: Icons.percent_rounded,
                          color: AppTheme.accentOrange),
                      const SizedBox(width: 8),
                      _StatBadge(
                          label:
                              '${assignedMembers.length} Members',
                          icon: Icons.people_rounded,
                          color: AppTheme.primaryColor),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 16),
                    const SizedBox(width: 3),
                    Text(trainer.rating.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.white38),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatBadge(
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
        mainAxisSize: MainAxisSize.min,
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

class TrainerDetailScreen extends StatelessWidget {
  final dynamic trainer;
  final List<dynamic> members;

  const TrainerDetailScreen(
      {super.key, required this.trainer, required this.members});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trainer.name,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(trainer.avatarUrl),
                  ),
                  const SizedBox(height: 12),
                  Text(trainer.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(trainer.role,
                      style: TextStyle(
                          color: AppTheme.primaryColor, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${trainer.rating} Rating',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _infoCard(context),
            const SizedBox(height: 24),
            const Text('Specializations',
                style:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (trainer.specializations as List<String>)
                  .map((s) =>
                      TagChip(label: s, color: AppTheme.primaryColor))
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text('Certifications',
                style:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            ...( trainer.certifications as List<String>).map((cert) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded,
                          color: AppTheme.accentGreen, size: 18),
                      const SizedBox(width: 8),
                      Text(cert,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            Text('Assigned Members (${members.length})',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            if (members.isEmpty)
              const Text('No assigned members',
                  style: TextStyle(color: Colors.white60))
            else
              ...members.map((m) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(m.avatarUrl),
                    ),
                    title: Text(m.name,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(m.goal,
                        style: const TextStyle(color: Colors.white60)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: m.isActive
                            ? AppTheme.accentGreen.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        m.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: m.isActive
                              ? AppTheme.accentGreen
                              : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Column(
        children: [
          _InfoRow2(
              label: 'Email',
              value: trainer.email,
              icon: Icons.email_rounded),
          _InfoRow2(
              label: 'Phone',
              value: trainer.phone,
              icon: Icons.phone_rounded),
          _InfoRow2(
              label: 'Commission',
              value: '${trainer.commissionPercentage}%',
              icon: Icons.percent_rounded),
          _InfoRow2(
              label: 'Monthly Salary',
              value: '\$${trainer.monthlySalary.toStringAsFixed(0)}',
              icon: Icons.attach_money_rounded),
          _InfoRow2(
              label: 'Joined',
              value: trainer.joinDate,
              icon: Icons.calendar_today_rounded),
        ],
      ),
    );
  }
}

class _InfoRow2 extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow2(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white60)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
