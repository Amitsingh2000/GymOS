import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../shared/role_selection_screen.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key});

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

    // Days since joining
    final joinDate = DateTime.tryParse(member.joinDate) ?? DateTime.now();
    final daysSinceJoin = DateTime.now().difference(joinDate).inDays;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Profile Hero ──────────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(member.avatarUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: member.isActive
                              ? AppTheme.accentGreen
                              : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.darkBg, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  member.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(member.email,
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 10),
                TagChip(label: member.goal, color: AppTheme.primaryColor),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Quick Stats ───────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  value: '${member.weight.toStringAsFixed(1)} kg',
                  label: 'Weight',
                  color: AppTheme.accentBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  value: '${member.height.toStringAsFixed(0)} cm',
                  label: 'Height',
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  value: '$daysSinceJoin',
                  label: 'Days Active',
                  color: AppTheme.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Membership ────────────────────────────────────────────────────
          const SectionHeader(title: 'Membership'),
          const SizedBox(height: 14),
          if (plan != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.15),
                    AppTheme.darkCard,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.card_membership_rounded,
                            color: AppTheme.primaryColor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16)),
                            Text('\$${plan.monthlyPrice.toStringAsFixed(0)}/month',
                                style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          member.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                              color: member.isActive
                                  ? AppTheme.accentGreen
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: AppTheme.darkBorder),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoRow(label: 'Joined', value: member.joinDate),
                      _InfoRow(label: 'Expires', value: member.expiryDate),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // ── Trainer ───────────────────────────────────────────────────────
          if (trainer != null) ...[
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
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        Text(trainer.role,
                            style: const TextStyle(
                                color: AppTheme.primaryColor, fontSize: 13)),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 14),
                            const SizedBox(width: 3),
                            Text(trainer.rating.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(width: 10),
                            const Icon(Icons.check_circle_rounded,
                                color: AppTheme.accentGreen, size: 14),
                            const SizedBox(width: 3),
                            Text(trainer.specializations.isNotEmpty
                                    ? trainer.specializations.first
                                    : 'Trainer',
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.message_rounded,
                        color: AppTheme.primaryColor),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Messaging coming soon!')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // ── Contact Info ──────────────────────────────────────────────────
          const SectionHeader(title: 'Contact Info'),
          const SizedBox(height: 14),
          _ContactCard(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: member.phone,
            color: AppTheme.accentGreen,
          ),
          const SizedBox(height: 8),
          _ContactCard(
            icon: Icons.email_rounded,
            label: 'Email',
            value: member.email,
            color: AppTheme.accentBlue,
          ),
          const SizedBox(height: 24),

          // ── Settings ──────────────────────────────────────────────────────
          const SectionHeader(title: 'Settings'),
          const SizedBox(height: 14),
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            label: 'Dark Mode',
            trailing: Switch(
              value: p.isDarkMode,
              onChanged: (_) => p.toggleTheme(),
              activeTrackColor: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.notifications_rounded,
            label: 'Notifications',
            trailing: Switch(
              value: true,
              onChanged: (_) {},
              activeTrackColor: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),

          // ── Logout ────────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
              ),
              icon: const Icon(Icons.logout_rounded, color: Colors.red),
              label: const Text('Logout',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatTile(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 11)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          trailing,
        ],
      ),
    );
  }
}
