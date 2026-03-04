import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import 'owner_dashboard_screen.dart';
import 'equipment_list_screen.dart';
import 'exercise_library_screen.dart';
import 'membership_plans_screen.dart';
import 'staff_screen.dart';
import '../shared/role_selection_screen.dart';

class OwnerShell extends StatefulWidget {
  const OwnerShell({super.key});

  @override
  State<OwnerShell> createState() => _OwnerShellState();
}

class _OwnerShellState extends State<OwnerShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const OwnerDashboardScreen(),
    const EquipmentListScreen(),
    const ExerciseLibraryScreen(),
    const MembershipPlansScreen(),
    const StaffScreen(),
  ];

  final _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_rounded),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.fitness_center_rounded),
      label: 'Equipment',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports_gymnastics_rounded),
      label: 'Exercises',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.card_membership_rounded),
      label: 'Plans',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people_rounded),
      label: 'Staff',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.fitness_center_rounded, color: AppTheme.primaryColor),
        ),
        title: const Text(
          'GymOS',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () => provider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.darkBorder, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: _navItems,
        ),
      ),
    );
  }
}
