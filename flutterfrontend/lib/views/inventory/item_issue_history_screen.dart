import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/inventory_provider.dart';

class ItemIssueHistoryPage extends ConsumerWidget {
  final String itemId;
  final String itemName;
  const ItemIssueHistoryPage({super.key, required this.itemId, required this.itemName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issued = ref.watch(inventoryProvider.notifier).issuedItems
        .where((e) => e['itemId'] == itemId)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Issue History: $itemName', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: issued.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  const Text('No issues for this item yet', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: issued.length,
              itemBuilder: (context, index) {
                final issue = issued[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.event, color: Colors.orange),
                    ),
                    title: Text('Issued to: ${issue['eventName']}', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Quantity: ${issue['quantity']}'),
                        Text('Date: ${issue['issueDate']} • Remaining: ${issue['remainingQuantity']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}


