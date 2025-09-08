import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/inventory_provider.dart';

class ItemIssueHistoryPage extends ConsumerStatefulWidget {
  final String itemId;
  final String itemName;
  const ItemIssueHistoryPage(
      {super.key, required this.itemId, required this.itemName});

  @override
  ConsumerState<ItemIssueHistoryPage> createState() =>
      _ItemIssueHistoryPageState();
}

class _ItemIssueHistoryPageState extends ConsumerState<ItemIssueHistoryPage> {
  Map<String, dynamic>? historyData;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response =
          await ref.read(inventoryProvider.notifier).getIssuanceHistoryByItemId(
                itemId: int.parse(widget.itemId),
              );

      setState(() {
        historyData = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Issue History: ${widget.itemName}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
            const SizedBox(height: 12),
            Text('Error loading history',
                style: TextStyle(color: Colors.red[600])),
            const SizedBox(height: 8),
            Text(error!,
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHistory,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (historyData == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text('No history data available',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final issuanceHistory =
        historyData!['data']['issuance_history'] as List<dynamic>;
    final itemInfo = historyData!['data']['item_info'] as Map<String, dynamic>;
    final summary = historyData!['data']['summary'] as Map<String, dynamic>;

    if (issuanceHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text('No issues for this item yet',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Info Card
          _buildItemInfoCard(itemInfo),
          const SizedBox(height: 16),

          // Summary Card
          _buildSummaryCard(summary),
          const SizedBox(height: 16),

          // History List
          Text(
            'Issuance History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),

          ...issuanceHistory.map((issue) => _buildHistoryCard(issue)).toList(),
        ],
      ),
    );
  }

  Widget _buildItemInfoCard(Map<String, dynamic> itemInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Item Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Name', itemInfo['name']),
          _buildInfoRow('Category', itemInfo['category_name']),
          _buildInfoRow('Unit', itemInfo['unit']),
          _buildInfoRow('Storage Location', itemInfo['storage_location']),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem('Total Transactions',
                    summary['total_transactions'].toString()),
              ),
              Expanded(
                child: _buildSummaryItem(
                    'Total Issued', summary['total_issued'].toString()),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                    'Total Returned', summary['total_returned'].toString()),
              ),
              Expanded(
                child: _buildSummaryItem(
                    'Net Issued', summary['net_issued'].toString()),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSummaryItem(
              'Current Stock', summary['current_stock'].toString()),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> issue) {
    final isOut = issue['transaction_type'] == 'OUT';
    final issuedAt = DateTime.parse(issue['issued_at']);

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOut
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isOut ? Colors.red : Colors.green,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isOut ? 'ISSUED' : 'RETURNED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isOut ? Colors.red : Colors.green,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${issuedAt.day}/${issuedAt.month}/${issuedAt.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isOut ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isOut ? Colors.red : Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${issue['quantity_issued']} ${issue['unit']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (issue['notes'] != null &&
                issue['notes'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${issue['notes']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
            if (isOut) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showReturnDialog(issue),
                  icon: const Icon(Icons.undo, size: 16),
                  label: const Text('Return to Inventory'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showReturnDialog(Map<String, dynamic> issue) {
    final TextEditingController notesController = TextEditingController();
    double returnQuantity = double.parse(issue['quantity_issued'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Return to Inventory'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item: ${issue['item_name']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Quantity to return: ${returnQuantity.toStringAsFixed(0)} ${issue['unit']}'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Return Notes (Optional)',
                      hintText: 'Enter reason for return...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _processReturn(
                      issue: issue,
                      quantity: returnQuantity,
                      notes: notesController.text.trim(),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Return'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _processReturn({
    required Map<String, dynamic> issue,
    required double quantity,
    required String notes,
  }) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Processing return...'),
              ],
            ),
          );
        },
      );

      // Get event_id from the issue data
      // The issuance history API response now includes event_id
      int eventId = 0;
      if (issue['event_id'] != null) {
        eventId = int.parse(issue['event_id'].toString());
        print('🔍 Debug: Using event_id from issue data: $eventId');
      } else {
        // Fallback to 0 if event_id is somehow missing
        eventId = 0;
        print('🔍 Debug: event_id not found, using default: $eventId');
      }

      await ref.read(inventoryProvider.notifier).updateIssuance(
            id: issue['id'],
            itemId: issue['item_id'],
            transactionType: 'IN',
            quantity: quantity,
            eventId: eventId,
            notes: notes.isEmpty ? 'Returned to inventory' : notes,
          );

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item returned to inventory successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reload history data
      await _loadHistory();
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to return item: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
