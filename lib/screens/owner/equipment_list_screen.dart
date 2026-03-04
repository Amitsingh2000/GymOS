import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/equipment.dart';

class EquipmentListScreen extends StatefulWidget {
  const EquipmentListScreen({super.key});

  @override
  State<EquipmentListScreen> createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final categories = ['All', ...{...p.equipment.map((e) => e.category)}];
    final filtered = _selectedCategory == 'All'
        ? p.equipment
        : p.equipment.where((e) => e.category == _selectedCategory).toList();

    return Scaffold(
      body: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final selected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primaryColor
                          : AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppTheme.primaryColor
                            : AppTheme.darkBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white60,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.fitness_center_rounded,
                    message: 'No equipment found')
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _EquipmentCard(eq: filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Equipment'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddEquipmentSheet(),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  final GymEquipment eq;
  const _EquipmentCard({required this.eq});

  @override
  Widget build(BuildContext context) {
    final conditionColor = AppTheme.conditionColor(eq.condition);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EquipmentDetailScreen(eq: eq)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                eq.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: AppTheme.darkBorder,
                  child: const Icon(Icons.fitness_center_rounded,
                      color: Colors.white24, size: 40),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eq.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${eq.brand} • ${eq.location}',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TagChip(label: eq.category, color: AppTheme.accentBlue),
                        const SizedBox(width: 6),
                        TagChip(label: eq.condition, color: conditionColor),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Last maintenance: ${eq.lastMaintenanceDate}',
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded,
                  color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}

class EquipmentDetailScreen extends StatelessWidget {
  final GymEquipment eq;
  const EquipmentDetailScreen({super.key, required this.eq});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eq.name,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              eq.imageUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: AppTheme.darkCard,
                child: const Icon(Icons.fitness_center_rounded,
                    color: Colors.white24, size: 80),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TagChip(label: eq.category, color: AppTheme.accentBlue),
                      const SizedBox(width: 8),
                      TagChip(
                          label: eq.condition,
                          color: AppTheme.conditionColor(eq.condition)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(label: 'Brand', value: eq.brand),
                  _InfoRow(label: 'Location', value: eq.location),
                  _InfoRow(label: 'Purchase Date', value: eq.purchaseDate),
                  _InfoRow(
                      label: 'Last Maintenance', value: eq.lastMaintenanceDate),
                  _InfoRow(
                      label: 'Next Due', value: eq.nextMaintenanceDue),
                  const SizedBox(height: 20),
                  const Text(
                    'Downtime Logs',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  if (eq.downtimeLogs.isEmpty)
                    const Text('No downtime recorded ✅',
                        style: TextStyle(color: Colors.white60))
                  else
                    ...eq.downtimeLogs.map((log) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.red.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.orange, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(log.reason,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                    Text(
                                        '${log.date} • ${log.duration}',
                                        style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _AddEquipmentSheet extends StatefulWidget {
  const _AddEquipmentSheet();

  @override
  State<_AddEquipmentSheet> createState() => _AddEquipmentSheetState();
}

class _AddEquipmentSheetState extends State<_AddEquipmentSheet> {
  final _nameController = TextEditingController();
  String _category = 'Cardio';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Equipment',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Equipment Name'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            dropdownColor: AppTheme.darkCard,
            items: ['Cardio', 'Free Weights', 'Machines', 'Strength']
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _category = v ?? _category),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Save Equipment'),
            ),
          ),
        ],
      ),
    );
  }
}
