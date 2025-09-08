import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/event_provider.dart';
import '../event/event_screen.dart';

class IssueInventoryPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> inventoryItem;

  const IssueInventoryPage({super.key, required this.inventoryItem});

  @override
  ConsumerState<IssueInventoryPage> createState() => _IssueInventoryPageState();
}

class _IssueInventoryPageState extends ConsumerState<IssueInventoryPage> {
  Map<String, dynamic>? selectedEvent;
  int issueQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Issue ${widget.inventoryItem['name']}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.inventory_2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.inventoryItem['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.inventoryItem['category']} • ${widget.inventoryItem['material']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quantity
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.numbers, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('Issue Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        onPressed: issueQuantity > 1 ? () => setState(() => issueQuantity--) : null,
                        icon: Icon(Icons.remove_circle_outline, color: issueQuantity > 1 ? Colors.blue : Colors.grey),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            issueQuantity.toString(),
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: issueQuantity < (widget.inventoryItem['quantity'] ?? 0)
                            ? () => setState(() => issueQuantity++)
                            : null,
                        icon: Icon(Icons.add_circle_outline, color: issueQuantity < (widget.inventoryItem['quantity'] ?? 0) ? Colors.blue : Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Events
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.purple.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.event, color: Colors.purple, size: 20),
                      SizedBox(width: 8),
                      Text('Select Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (events.isEmpty)
                    Center(
                      child: Text('No events available', style: TextStyle(color: Colors.grey[600])),
                    )
                  else ...events.map((event) {
                    final eventMap = {
                      'id': event.id.toString(),
                      'name': event.name ?? '',
                      'date': event.date?.toIso8601String() ?? '',
                      'location': event.location ?? '',
                      'status': event.status ?? '',
                    };
                    final isSelected = selectedEvent?['id'] == eventMap['id'];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: Icon(Icons.event, color: isSelected ? AppColors.primary : Colors.grey[600]),
                      title: Text(eventMap['name']!),
                      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                      onTap: () => setState(() => selectedEvent = eventMap),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Issue button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: selectedEvent == null ? null : _confirmIssue,
                icon: const Icon(Icons.send),
                label: const Text('Issue to Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmIssue() {
    ref.read(inventoryProvider.notifier).issueInventory(
      widget.inventoryItem['id'],
      issueQuantity,
      selectedEvent!['name'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Success!'),
          ],
        ),
        content: Text('${issueQuantity} × ${widget.inventoryItem['name']} issued to ${selectedEvent!['name']}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}


