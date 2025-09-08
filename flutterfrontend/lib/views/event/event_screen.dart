import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../auth/login_screen.dart';
import 'event_details_screen.dart';
import 'add_event_screen.dart';
import 'add_simple_event_screen.dart';
import 'years_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/event_provider.dart';
import '../../providers/template_provider.dart';
import '../../models/event_model.dart';
import '../../models/event_template_model.dart';


/// ----------------------
/// Event Screen
/// ----------------------
class EventScreen extends ConsumerStatefulWidget {
  final bool isAdmin;
  const EventScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  ConsumerState<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {

  @override
  void initState() {
    super.initState();

    // Fetch events and templates on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventProvider.notifier).fetchEvents();
      ref.read(templateProvider.notifier).fetchTemplates();
    });
  }


  void _editEvent(EventModel eventData) async {
    final TextEditingController nameController = TextEditingController(text: eventData.name ?? '');

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
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
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context, {
                  'id': eventData.id,
                  'name': nameController.text.trim(),
                  'status': eventData.status,
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && eventData.id != null) {
      final updatedEvent = EventModel(
        id: eventData.id,
        name: result['name'],
        status: result['status'],
        location: eventData.location,
        description: eventData.description,
        date: eventData.date,
        templateId: eventData.templateId,
        yearId: eventData.yearId,
        coverImage: eventData.coverImage,
        createdAt: eventData.createdAt,
      );

      await ref.read(eventProvider.notifier).updateEvent(eventData.id!, updatedEvent);
    }
  }

  void _deleteEvent(EventModel eventData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${eventData.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (eventData.id != null) {
                await ref.read(eventProvider.notifier).deleteEvent(eventData.id!);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${eventData.name} deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allEventsData = ref.watch(eventProvider);
    final templates = ref.watch(templateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        // ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, Colors.white],
            stops: [0.0, 0.25],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              // Event Templates Section
              if (templates.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Event Templates',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(templateProvider.notifier).fetchTemplates();
                        },
                        icon: const Icon(Icons.refresh, color: AppColors.primary),
                        tooltip: 'Refresh Templates',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                            final template = templates[index];
                            final isEven = index % 2 == 0;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 1),
                              decoration: BoxDecoration(
                                color: isEven
                                    ? const Color(0xFFF0F0F0)
                                    : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to YearsScreen when template is clicked
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => YearsScreen(
                                          template: template,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: isEven
                                                ? const Color(0xFF25D366)
                                                : const Color(0xFF128C7E),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Icon(
                                            Icons.description,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                template.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: isEven
                                                      ? const Color(0xFF075E54)
                                                      : const Color(0xFF128C7E),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Colors.grey.shade400,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  ),
              ],
              // Events List Section
              Container(
                height: MediaQuery.of(context).size.height * 0.0, // Fixed height for events list
                child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: allEventsData.length,
                        itemBuilder: (context, index) {
                          final eventData = allEventsData[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  AppColors.secondary.withOpacity(0.1),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 25,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.shade100,
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  if (eventData.id != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => EventDetailsScreen(
                                          eventData: {
                                            'id': eventData.id.toString(),
                                            'name': eventData.name ?? '',
                                            'date': eventData.date?.toIso8601String() ?? '',
                                            'location': eventData.location ?? '',
                                            'status': eventData.status ?? '',
                                          },
                                          isAdmin: widget.isAdmin,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.primary,
                                              AppColors.primary.withOpacity(0.8),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.3),
                                              blurRadius: 15,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.event,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              eventData.name ?? 'Unnamed Event',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Event ID: ${eventData.id ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.primary.withOpacity(0.1),
                                                AppColors.primary.withOpacity(0.05),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(
                                              color: AppColors.primary.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.more_vert,
                                            color: AppColors.primary,
                                            size: 18,
                                          ),
                                        ),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _editEvent(eventData);
                                          } else if (value == 'delete') {
                                            _deleteEvent(eventData);
                                          } else if (value == 'view') {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => EventDetailsScreen(
                                                  eventData: {
                                                    'id': eventData.id.toString(),
                                                    'name': eventData.name ?? '',
                                                    'date': eventData.date?.toIso8601String() ?? '',
                                                    'location': eventData.location ?? '',
                                                    'status': eventData.status ?? '',
                                                  },
                                                  isAdmin: widget.isAdmin,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'view',
                                            child: Row(
                                              children: [
                                                Icon(Icons.visibility, size: 20),
                                                SizedBox(width: 8),
                                                Text('View Details'),
                                              ],
                                            ),
                                          ),
                                          if (widget.isAdmin) ...[
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, size: 20),
                                                  SizedBox(width: 8),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete, size: 20, color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 0,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
                             child: FloatingActionButton.extended(
                 heroTag: "event_add_button", // Added unique hero tag
                 onPressed: () async {
                   await Navigator.of(context).push(
                     MaterialPageRoute(builder: (_) => const AddSimpleEventScreen()),
                   );
                   // Refresh the event list and templates after adding
                   ref.read(eventProvider.notifier).fetchEvents();
                   ref.read(templateProvider.notifier).fetchTemplates();
                 },
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                label: const Text(
                  'Add Event',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            )
          : null,
    );
  }
}
