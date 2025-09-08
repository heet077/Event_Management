import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'inventory_screen.dart';
import '../../themes/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/inventory_provider.dart';
import '../event/event_screen.dart';
import '../../providers/event_provider.dart';
import 'issue_inventory_screen.dart';
import 'issued_items_screen.dart';
import 'item_issue_history_screen.dart';
import 'edit_inventory_screen.dart';

class InventoryListScreen extends ConsumerStatefulWidget {
  const InventoryListScreen({super.key});

  @override
  ConsumerState<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends ConsumerState<InventoryListScreen> {

  @override
  Widget build(BuildContext context) {
    final inventoryItems = ref.watch(inventoryProvider);
    final currentUser = ref.watch(authProvider);
    final isAdmin = currentUser?.role == 'admin';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Inventory Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
                 actions: [
          //  IconButton(
          //    onPressed: () {
          //      // TODO: Implement search functionality
          //    },
          //    icon: const Icon(Icons.search),
          //  ),
          //  IconButton(
          //    onPressed: () {
          //      // TODO: Implement filter functionality
          //    },
          //    icon: const Icon(Icons.filter_list),
          //  ),
           IconButton(
             onPressed: () => _navigateToIssuedItemsScreen(),
             icon: const Icon(Icons.history),
             tooltip: 'View Issued Items',
           ),
           IconButton(
             onPressed: () => _showLogoutDialog(context),
             icon: const Icon(Icons.logout),
             tooltip: 'Logout',
           ),
         ],
      ),
      body: Column(
        children: [
          // Header Section with Stats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.secondary,
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Inventory Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Total Items',
                        value: inventoryItems.length.toString(),
                        icon: Icons.inventory,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Categories',
                        value: '7',
                        icon: Icons.category,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Low Stock',
                        value: inventoryItems.where((item) => item.status == 'Low Stock').length.toString(),
                        icon: Icons.warning,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // User access message for non-admin users
          if (!isAdmin) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
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
                      'You have read-only access to inventory. Contact an administrator to add, edit, or delete items.',
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
            const SizedBox(height: 16),
          ],
          
          // Inventory List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: inventoryItems.length,
              itemBuilder: (context, index) {
                final item = inventoryItems[index];
                return _buildInventoryCard(item.toMap(), isAdmin);
              },
            ),
          ),
        ],
      ),
                   floatingActionButton: isAdmin ? FloatingActionButton.extended(
        heroTag: "inventory_add_button", // Added unique hero tag
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InventoryFormPage(),
            ),
          );
         
         // Handle the result from form submission
         print('Form result received: $result');
         if (result != null && result is Map<String, dynamic>) {
           print('Result is valid map, adding to inventory');
           
           // Create new inventory item
           final newItem = InventoryItem(
             id: DateTime.now().millisecondsSinceEpoch.toString(),
             name: result['name'] ?? 'New Item',
             category: result['category'] ?? 'Unknown',
             material: result['material'] ?? 'Unknown',
             quantity: result['quantity'] ?? 1,
             location: result['location'] ?? 'Unknown',
             lastUpdated: DateTime.now().toString().split(' ')[0],
             status: (result['quantity'] ?? 0) > 5 ? 'In Stock' : 'Low Stock',
             imageBytes: result['imageBytes'] != null ? Uint8List.fromList(result['imageBytes']) : null,
             imageName: result['imageName'],
           );
           
           print('New item created: ${newItem.toMap()}');
           
           // Add to provider
           ref.read(inventoryProvider.notifier).addItem(newItem);
           print('Inventory items count: ${inventoryItems.length}');
           
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('${result['name']} added to inventory successfully!'),
               backgroundColor: Colors.green,
               behavior: SnackBarBehavior.floating,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(12),
               ),
             ),
           );
         } else {
           print('Result is null or not a map: $result');
         }
       },
       backgroundColor: AppColors.primary,
       foregroundColor: Colors.white,
       icon: const Icon(Icons.add),
       label: const Text('Add Inventory'),
       elevation: 4,
     ) : null,
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

    Widget _buildInventoryCard(Map<String, dynamic> item, bool isAdmin) {
    return Opacity(
      opacity: isAdmin ? 1.0 : 0.7,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(item['category']),
              color: AppColors.primary,
              size: 24,
            ),
          ),
          title: Text(
            item['name'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                '${item['category']} • ${item['material']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item['location'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 4),
              Text(
                'Qty: ${item['quantity']}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          onTap: isAdmin ? () {
            _showItemOptions(context, item);
          } : null,
        ),
      ),
    );
  }

  void _showItemOptions(BuildContext context, Map<String, dynamic> item) {
    final currentUser = ref.read(authProvider);
    final isAdmin = currentUser?.role == 'admin';
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Admin-only actions
            if (isAdmin) ...[
              ListTile(
                leading: Icon(Icons.edit, color: AppColors.primary),
                title: Text('Edit ${item['name']}'),
                onTap: () {
                  Navigator.pop(context);
                  _editItem(item);
                },
              ),
              ListTile(
                leading: Icon(Icons.remove_circle_outline, color: Colors.red),
                title: Text('Delete ${item['name']}'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteItem(item);
                },
              ),
            ],
            // Both admin and user can issue to events
            ListTile(
              leading: Icon(Icons.event_note, color: Colors.orange),
              title: Text('Issue to Event'),
              onTap: () {
                Navigator.pop(context);
                _issueToEvent(item);
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.teal),
              title: const Text('View Issue History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemIssueHistoryPage(
                      itemId: item['id'],
                      itemName: item['name'],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _editItem(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditInventoryPage(itemId: item['id']),
      ),
    );
  }

  void _deleteItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${item['name']}?'),
        content: Text('Are you sure you want to delete this item? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(inventoryProvider.notifier).deleteItem(item['id']);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item['name']} deleted successfully!'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

     void _issueToEvent(Map<String, dynamic> item) {
     print('Opening issue screen for item: ${item['name']}');
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => IssueInventoryPage(inventoryItem: item),
       ),
     );
   }

   void _navigateToIssuedItemsScreen() {
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => const IssuedItemsPage(),
       ),
     );
   }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.logout();
      
      // Navigate back to login
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Logout error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

// Issued Items List Screen
class IssuedItemsListScreen extends ConsumerStatefulWidget {
  const IssuedItemsListScreen({super.key});

  @override
  ConsumerState<IssuedItemsListScreen> createState() => _IssuedItemsListScreenState();
}

class _IssuedItemsListScreenState extends ConsumerState<IssuedItemsListScreen> {
  @override
  Widget build(BuildContext context) {
    final issuedItems = ref.watch(inventoryProvider.notifier).issuedItems;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Issued Items to Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Section with Stats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.secondary,
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.history_edu,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Issued Items Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Total Issues',
                        value: issuedItems.length.toString(),
                        icon: Icons.inventory,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Unique Items',
                        value: issuedItems.map((item) => item['itemId']).toSet().length.toString(),
                        icon: Icons.category,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Events',
                        value: issuedItems.map((item) => item['eventName']).toSet().length.toString(),
                        icon: Icons.event,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Issued Items List
          Expanded(
            child: issuedItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: issuedItems.length,
                    itemBuilder: (context, index) {
                      final item = issuedItems[index];
                      return _buildIssuedItemCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_edu,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'No items issued yet',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'When you issue inventory items to events, they will appear here',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back to Inventory'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssuedItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.event_note,
            color: Colors.orange,
            size: 24,
          ),
        ),
        title: Text(
          '${item['quantity']} × ${item['itemName']}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.event,
                  size: 16,
                  color: Colors.purple,
                ),
                const SizedBox(width: 4),
                Text(
                  'Event: ${item['eventName']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Issued: ${item['issueDate']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.inventory,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  'Remaining: ${item['remainingQuantity']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.orange,
              width: 1,
            ),
          ),
          child: Text(
            'Issued',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}

// Inventory Issue Screen
class InventoryIssueScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> inventoryItem;

  const InventoryIssueScreen({super.key, required this.inventoryItem});

  @override
  ConsumerState<InventoryIssueScreen> createState() => _InventoryIssueScreenState();
}

class _InventoryIssueScreenState extends ConsumerState<InventoryIssueScreen> {
  // Get real events from the event provider
  List<Map<String, dynamic>> get currentEvents {
    final events = ref.watch(eventProvider);
    return events.map((e) => {
      'id': e.id.toString(),
      'name': e.name ?? '',
      'date': e.date?.toIso8601String() ?? '',
      'location': e.location ?? '',
      'status': e.status ?? '',
    }).toList();
  }

  Map<String, dynamic>? selectedEvent;
  int issueQuantity = 1;

  @override
  void initState() {
    super.initState();
    // Debug: Print events to console
    print('Current Events: ${currentEvents.length}');
    for (var event in currentEvents) {
      print('Event: ${event['name']} - ${event['date']}');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Inventory Item Card
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Item Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Item Image or Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: widget.inventoryItem['imageBytes'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Image.memory(
                                  widget.inventoryItem['imageBytes'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      _getCategoryIcon(widget.inventoryItem['category']),
                                      color: AppColors.primary,
                                      size: 32,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                _getCategoryIcon(widget.inventoryItem['category']),
                                color: AppColors.primary,
                                size: 32,
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.inventoryItem['category'],
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
                                Text(
                                  widget.inventoryItem['material'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
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
                                Text(
                                  widget.inventoryItem['location'] ?? 'No location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inventory,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Available: ${widget.inventoryItem['quantity']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quantity Selection
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
                    children: [
                      Icon(
                        Icons.numbers,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Issue Quantity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: issueQuantity > 1
                              ? () => setState(() => issueQuantity--)
                              : null,
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: issueQuantity > 1 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                issueQuantity.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'units',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: issueQuantity < widget.inventoryItem['quantity']
                              ? () => setState(() => issueQuantity++)
                              : null,
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: issueQuantity < widget.inventoryItem['quantity'] ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                                     Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         'Available: ${ref.watch(inventoryProvider).firstWhere((item) => item.id == widget.inventoryItem['id'], orElse: () => InventoryItem(id: '', name: '', category: '', material: '', quantity: 0, location: '', lastUpdated: '', status: '')).quantity}',
                         style: TextStyle(
                           fontSize: 14,
                           color: Colors.grey[600],
                         ),
                       ),
                       Text(
                         'Remaining: ${ref.watch(inventoryProvider).firstWhere((item) => item.id == widget.inventoryItem['id'], orElse: () => InventoryItem(id: '', name: '', category: '', material: '', quantity: 0, location: '', lastUpdated: '', status: '')).quantity - issueQuantity}',
                         style: TextStyle(
                           fontSize: 14,
                           fontWeight: FontWeight.w600,
                           color: (ref.watch(inventoryProvider).firstWhere((item) => item.id == widget.inventoryItem['id'], orElse: () => InventoryItem(id: '', name: '', category: '', material: '', quantity: 0, location: '', lastUpdated: '', status: '')).quantity - issueQuantity) < 5 ? Colors.orange : Colors.green,
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Event Selection
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
                    children: [
                      Icon(
                        Icons.event,
                        color: Colors.purple,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select Event (${currentEvents.length} available)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                                     if (currentEvents.isEmpty)
                     Container(
                       padding: const EdgeInsets.all(20),
                       decoration: BoxDecoration(
                         color: Colors.grey[100],
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child: Column(
                         children: [
                           Icon(
                             Icons.event_busy,
                             size: 48,
                             color: Colors.grey[400],
                           ),
                           const SizedBox(height: 16),
                           const Text(
                             'No events available',
                             style: TextStyle(
                               color: Colors.grey,
                               fontSize: 18,
                               fontWeight: FontWeight.w600,
                             ),
                           ),
                           const SizedBox(height: 8),
                           Text(
                             'Create some events first to issue inventory',
                             style: TextStyle(
                               color: Colors.grey[500],
                               fontSize: 14,
                             ),
                             textAlign: TextAlign.center,
                           ),
                           const SizedBox(height: 16),
                           ElevatedButton.icon(
                             onPressed: () {
                               Navigator.pop(context);
                               // Navigate to events tab
                               // This will be handled by the parent navigation
                             },
                             icon: const Icon(Icons.add),
                             label: const Text('Create Event'),
                             style: ElevatedButton.styleFrom(
                               backgroundColor: AppColors.primary,
                               foregroundColor: Colors.white,
                             ),
                           ),
                         ],
                       ),
                     )
                   else
                     ...currentEvents.map((event) => _buildEventCard(event)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // This Item's Issue History Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.15),
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
                    children: [
                      Icon(
                        Icons.history_edu,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Issue History for ${widget.inventoryItem['name']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildItemIssueHistory(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recently Issued Items Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.green.withOpacity(0.15),
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
                    children: [
                      Icon(
                        Icons.history,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recently Issued Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildIssuedItemsList(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Issue Button
            Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: selectedEvent != null
                      ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
                      : [Colors.grey, Colors.grey.withOpacity(0.8)],
                ),
                boxShadow: selectedEvent != null
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: selectedEvent != null
                    ? () => _issueInventory()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedEvent != null
                          ? 'Issue to ${selectedEvent!['name']}'
                          : 'Select an Event First',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final isSelected = selectedEvent?['id'] == event['id'];
    
    return GestureDetector(
      onTap: () => setState(() => selectedEvent = event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.event,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Event ID: ${event['id']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Created: ${event['date'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
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
    );
  }

  void _issueInventory() {
    if (selectedEvent != null) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Issue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to issue:'),
              const SizedBox(height: 8),
              Text(
                '${issueQuantity} × ${widget.inventoryItem['name']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('to event: ${selectedEvent!['name']}?'),
              const SizedBox(height: 8),
              Text(
                'Available after issue: ${widget.inventoryItem['quantity'] - issueQuantity}',
                style: TextStyle(
                  color: (widget.inventoryItem['quantity'] - issueQuantity) < 5 ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.w500,
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
                Navigator.pop(context); // Close confirmation dialog
                _confirmIssue();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm Issue'),
            ),
          ],
        ),
      );
    }
  }

  void _confirmIssue() {
    // Update inventory quantity using the provider
    ref.read(inventoryProvider.notifier).issueInventory(
      widget.inventoryItem['id'],
      issueQuantity,
      selectedEvent!['name'],
    );
    
    // Show success message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            const Text('Success!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${issueQuantity} × ${widget.inventoryItem['name']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('has been issued to ${selectedEvent!['name']}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.inventory, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Remaining: ${widget.inventoryItem['quantity'] - issueQuantity}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Inventory quantity has been updated. The change will be reflected across all screens.',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to inventory list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
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
   
       Widget _buildItemIssueHistory() {
      final issuedItems = ref.read(inventoryProvider.notifier).issuedItems;
      
      // Filter items for this specific inventory item
      final itemIssues = issuedItems.where((item) => item['itemId'] == widget.inventoryItem['id']).toList();
      
      if (itemIssues.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'No issues for this item yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'When you issue this item to events, they will appear here',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      
      return Column(
        children: itemIssues.map((issue) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.orange.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.event_note,
                  color: Colors.orange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${issue['quantity']} units issued',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Event: ${issue['eventName']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Date: ${issue['issueDate']} • Remaining: ${issue['remainingQuantity']}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      );
    }
    
    Widget _buildIssuedItemsList() {
      final issuedItems = ref.read(inventoryProvider.notifier).issuedItems;
      
      if (issuedItems.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'No items issued yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Issued items will appear here',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      
      // Show last 5 issued items
      final recentItems = issuedItems.take(5).toList();
      
      return Column(
        children: recentItems.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['quantity']} × ${item['itemName']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Issued to: ${item['eventName']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Date: ${item['issueDate']} • Remaining: ${item['remainingQuantity']}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      );
    }
 }
