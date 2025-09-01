// event_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// AppColors used for consistency with theme
class AppColors {
  static const Color primary = Color(0xFF2F4156);
  static const Color secondary = Color(0xFFF5EFE8);
  static const Color background = Color(0xFFC8D9E6);
  static const Color accentIcon = Color(0xFF2F4156);
  static const Color cardShadow = Color(0x1A000000);
  static const Color chartDivider = Color(0xFFE0E0E0);
}

class StatItem {
  final String title;
  final int value;
  final IconData icon;

  StatItem({required this.title, required this.value, required this.icon});
}

class CostDataItem {
  final int year;
  final double cost;

  CostDataItem({required this.year, required this.cost});
}

class EventDashboardData {
  final List<StatItem> statItems;
  final List<CostDataItem> yearlyCosts;

  EventDashboardData()
      : statItems = [
    StatItem(title: 'Templates', value: 24, icon: Icons.description),
    StatItem(title: 'Years', value: 5, icon: Icons.calendar_today),
    StatItem(title: 'Events', value: 142, icon: Icons.event),
    StatItem(title: 'Materials', value: 856, icon: Icons.inventory),
  ],
        yearlyCosts = [
          CostDataItem(year: 2020, cost: 40000),
          CostDataItem(year: 2021, cost: 50000),
          CostDataItem(year: 2022, cost: 45000),
          CostDataItem(year: 2023, cost: 60000),
          CostDataItem(year: 2024, cost: 55000),
        ];
}

final eventDashboardDataProvider = Provider<EventDashboardData>((ref) {
  return EventDashboardData();
});

class EventDashboardScreen extends ConsumerWidget {
  const EventDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardData = ref.watch(eventDashboardDataProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Event Dashboard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StatsGrid(statItems: dashboardData.statItems),
            const SizedBox(height: 20),
            YearlyCostBreakdownChart(yearlyCosts: dashboardData.yearlyCosts),
          ],
        ),
      ),
    );
  }
}

class StatsGrid extends StatelessWidget {
  final List<StatItem> statItems;
  const StatsGrid({super.key, required this.statItems});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: statItems.length,
      itemBuilder: (_, i) => StatCard(item: statItems[i]),
    );
  }
}

class StatCard extends StatelessWidget {
  final StatItem item;
  const StatCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(item.icon, size: 30, color: AppColors.accentIcon),
            ],
          ),
          Text(
            item.value.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class YearlyCostBreakdownChart extends StatelessWidget {
  final List<CostDataItem> yearlyCosts;
  const YearlyCostBreakdownChart({super.key, required this.yearlyCosts});

  @override
  Widget build(BuildContext context) {
    const maxChartValue = 75000.0;
    const chartHeight = 150.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Yearly Cost Breakdown', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [75, 50, 25, 0].map((v) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('${v}k', style: Theme.of(context).textTheme.bodySmall),
                )).toList(),
              ),
              const SizedBox(width: 8),
              Container(width: 1, height: chartHeight + 20, color: AppColors.chartDivider),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: chartHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: yearlyCosts.map((item) {
                          final barHeight = (item.cost / maxChartValue) * chartHeight;
                          return Container(
                            width: 28,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: AppColors.chartDivider),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: yearlyCosts.map((item) => Text(
                        item.year.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      )).toList(),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
