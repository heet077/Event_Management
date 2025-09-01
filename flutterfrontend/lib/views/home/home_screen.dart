import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bottom_nav_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../event/event_screen.dart';
import '../inventory/inventory_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final user = ref.watch(authProvider);
    final bool isAdmin = user?.role == 'admin';

    final List<Widget> screens = [
      const EventDashboardScreen(),
      EventScreen(isAdmin: isAdmin), // ✅ Pass dynamically
      const InventoryListScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        backgroundColor: Colors.white,
        activeColor: Theme.of(context).primaryColor,
        color: Colors.grey[600],
        height: 60,
        elevation: 2,
        items: const [
          TabItem(icon: Icon(Icons.dashboard), title: 'Dashboard'),
          TabItem(icon: Icon(Icons.event), title: 'Events'),
          TabItem(icon: Icon(Icons.inventory), title: 'Inventory'),
        ],
        initialActiveIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
