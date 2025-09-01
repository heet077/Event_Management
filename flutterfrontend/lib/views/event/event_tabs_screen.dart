import 'package:avd_decoration_application/views/event/widget/cost_tab.dart';
import 'package:avd_decoration_application/views/event/widget/design_tab.dart';
import 'package:avd_decoration_application/views/event/widget/material_tab.dart';
import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class EventTabsScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  final bool isAdmin;

  const EventTabsScreen({Key? key, required this.event, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${event['name']} (${event['year']})'),
          bottom: const TabBar(
            labelColor: AppColors.background,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            indicatorColor: AppColors.secondary,
            indicatorWeight: 4,
            tabs: [
              Tab(text: 'Inventory'),
              Tab(text: 'Design'),
              Tab(text: 'Cost'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MaterialTab(event: event, isAdmin: isAdmin),
            DesignTab(event: event, isAdmin: isAdmin),
            CostTab(event: event, isAdmin: isAdmin),
          ],
        ),
      ),
    );
  }
}