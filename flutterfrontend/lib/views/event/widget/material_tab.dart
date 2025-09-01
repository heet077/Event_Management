import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/app_theme.dart';
import '../../../providers/inventory_provider.dart';

class MaterialTab extends ConsumerStatefulWidget {
  final Map<String, dynamic> event;
  final bool isAdmin;

  const MaterialTab({Key? key, required this.event, required this.isAdmin}) : super(key: key);

  @override
  ConsumerState<MaterialTab> createState() => _MaterialTabState();
}

class _MaterialTabState extends ConsumerState<MaterialTab> {
  Map<String, dynamic>? selectedItem;
  int issueQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final inventoryItems = ref.watch(inventoryProvider);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey.shade50],
          stops: const [0.0, 0.3],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                children: [
                      Expanded(
                        child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                              'Available Inventory',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                              'Total: ${inventoryItems.length} items',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Event: ${widget.event['name']} (${widget.event['year']})',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Issue Button Row (only show when item is selected)
                  if (widget.isAdmin && selectedItem != null) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _showIssueDialog(context, selectedItem!),
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.send, color: Colors.white, size: 20),
                          ),
                          label: const Text(
                            'Issue to Event',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
                  
                  // User access message
                  if (!widget.isAdmin) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You have read-only access. Contact an administrator to issue inventory items.',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Inventory Items List
            ...inventoryItems.map((item) => _buildInventoryCard(item.toMap())),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    final isSelected = selectedItem?['id'] == item['id'];
    
    return GestureDetector(
      onTap: () => setState(() => selectedItem = isSelected ? null : item),
          child: Container(
        margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
            colors: isSelected 
                ? [AppColors.primary.withOpacity(0.1), AppColors.primary.withOpacity(0.05)]
                : [Colors.white, Colors.grey.shade50],
              ),
              boxShadow: [
                BoxShadow(
              color: isSelected 
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.black.withOpacity(0.06),
                  blurRadius: 25,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
              ),
            ),
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
                children: [
              // Item Image or Icon
                      Container(
                width: 70,
                height: 70,
                        decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                ),
                child: item['imageBytes'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          item['imageBytes'],
                                  fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              _getCategoryIcon(item['category']),
                                    color: AppColors.primary,
                              size: 32,
                            );
                          },
                                  ),
                                )
                              : Icon(
                        _getCategoryIcon(item['category']),
                                  color: AppColors.primary,
                        size: 32,
                                ),
                        ),
              const SizedBox(width: 16),
              
              // Item Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                      item['name'],
                              style: TextStyle(
                        fontSize: 18,
                                fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primary : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['category'],
                              style: TextStyle(
                          fontSize: 12,
                                fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.style,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item['material'] ?? 'N/A',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item['location'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              
              // Quantity and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                    Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                      color: _getStatusColor(item['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                        color: _getStatusColor(item['status']),
                          width: 1,
                        ),
                      ),
                    child: Text(
                      item['status'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(item['status']),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Qty: ${item['quantity']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              
              // Selection Indicator
              if (isSelected)
                          Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIssueDialog(BuildContext context, Map<String, dynamic> item) {
    issueQuantity = 1;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.send, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              const Text('Issue to Event'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                'Issue ${item['name']} to ${widget.event['name']}?',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Quantity: ', style: TextStyle(fontSize: 16)),
                  IconButton(
                    onPressed: issueQuantity > 1
                        ? () => setDialogState(() => issueQuantity--)
                        : null,
                    icon: Icon(Icons.remove_circle_outline, color: issueQuantity > 1 ? AppColors.primary : Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      issueQuantity.toString(),
                                  style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: issueQuantity < item['quantity']
                        ? () => setDialogState(() => issueQuantity++)
                        : null,
                    icon: Icon(
                      Icons.add_circle_outline, 
                      color: issueQuantity < item['quantity'] ? AppColors.primary : Colors.grey
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
                                Text(
                'Available: ${item['quantity']} | Remaining: ${item['quantity'] - issueQuantity}',
                                  style: TextStyle(
                                    fontSize: 14,
                  color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(inventoryProvider.notifier).issueInventory(
                  item['id'], 
                  issueQuantity, 
                  widget.event['name']
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${issueQuantity} × ${item['name']} issued to ${widget.event['name']}'),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {
                  selectedItem = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Issue'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Furniture':
        return Icons.chair;
      case 'Fabric':
        return Icons.texture;
      case 'Frame Structure':
        return Icons.photo_library;
      case 'Carpet':
        return Icons.style;
      case 'Thermocol Material':
        return Icons.inbox;
      case 'Stationery':
        return Icons.edit;
      case 'Murti Set':
        return Icons.auto_awesome;
      default:
        return Icons.inventory;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      case 'Out of Stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}