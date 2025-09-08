import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/year_provider.dart';
import '../../providers/event_provider.dart';
import '../../models/year_model.dart';
import '../../models/event_template_model.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import 'add_event_screen.dart';
import 'event_tabs_screen.dart';
import 'add_year_screen.dart';

import 'event_details_screen.dart';

class YearsScreen extends ConsumerStatefulWidget {
  final EventTemplateModel template;
  
  const YearsScreen({
    Key? key,
    required this.template,
  }) : super(key: key);

  @override
  ConsumerState<YearsScreen> createState() => _YearsScreenState();
}

class _YearsScreenState extends ConsumerState<YearsScreen> {
  late Future<List<YearModel>> _yearsFuture;
  bool _isLoadingDetails = false;

  @override
  void initState() {
    super.initState();
    _yearsFuture = ref.read(yearServiceProvider).fetchYears();
  }

  Future<void> _refreshYears() async {
    setState(() {
      _yearsFuture = ref.read(yearServiceProvider).fetchYears();
    });
  }

  Future<void> _navigateToEventTabs(YearModel year) async {
    if (_isLoadingDetails) return;

    setState(() {
      _isLoadingDetails = true;
    });

    try {
      // Create API service and event service
      final apiService = ApiService(apiBaseUrl);
      final eventService = EventService(apiService);

      // Call the getDetails API
      final eventDetails = await eventService.getEventDetails(
        templateId: widget.template.id,
        yearId: year.id,
      );

      print('Event details response: $eventDetails');
      print('Template ID: ${widget.template.id}');
      print('Event ID from data.event.id: ${eventDetails['data']?['event']?['id']}');
      print('Event ID from response: ${eventDetails['id'] ?? eventDetails['event_id']}');
      print('Full response keys: ${eventDetails.keys.toList()}');
      print('Response type: ${eventDetails.runtimeType}');

      if (mounted) {
        // Navigate to EventTabsScreen with the API response data
        // Extract event ID from the correct path: data.event.id
        int eventId = eventDetails['data']?['event']?['id'] ?? 
                     eventDetails['id'] ?? 
                     eventDetails['event_id'] ?? 
                     eventDetails['eventId'] ??
                     year.id ?? // Try using year ID as event ID
                     widget.template.id; // Fallback to template ID
        
        print('Final event ID being used: $eventId');
        
        // Create a unique event object that includes year-specific data
        Map<String, dynamic> eventData = {
          'id': eventId,
          'name': widget.template.name,
          'year': year.yearName,
          'yearId': year.id, // Include year ID for proper isolation
          'templateId': widget.template.id, // Include template ID
          'createdAt': year.createdAt,
          'details': eventDetails, // Include API response data
        };
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EventTabsScreen(
              event: eventData,
              isAdmin: true, // You can adjust this based on your needs
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to load event details: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDetails = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Years - ${widget.template.name}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, Colors.white],
            stops: [0.0, 0.15],
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
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.secondary,
                            AppColors.secondary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.template.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              // Years List
              Expanded(
                child: FutureBuilder<List<YearModel>>(
                  future: _yearsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      );
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading years',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final years = snapshot.data ?? [];
                    
                    if (years.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.secondary.withOpacity(0.1),
                                    AppColors.secondary.withOpacity(0.05),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondary.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                size: 60,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No years available',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Years will appear here when available',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return RefreshIndicator(
                      onRefresh: _refreshYears,
                      color: AppColors.primary,
                      backgroundColor: Colors.white,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        itemCount: years.length,
                        itemBuilder: (context, index) {
                        final year = years[index];
                        final isEven = index % 2 == 0;
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isEven
                                        ? [
                                            const Color(0xFFE8F5E8),
                                            const Color(0xFFF1F8E9),
                                          ]
                                        : [
                                            Colors.white,
                                            const Color(0xFFFAFAFA),
                                          ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 8),
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
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      // Call API and navigate to EventTabsScreen when year is clicked
                                      _navigateToEventTabs(year);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: isEven
                                                    ? [
                                                        const Color(0xFF4CAF50),
                                                        const Color(0xFF2E7D32),
                                                      ]
                                                    : [
                                                        const Color(0xFF25D366),
                                                        const Color(0xFF128C7E),
                                                      ],
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: (isEven 
                                                      ? const Color(0xFF4CAF50) 
                                                      : const Color(0xFF25D366)).withOpacity(0.3),
                                                  blurRadius: 12,
                                                  spreadRadius: 0,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  year.yearName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: isEven
                                                        ? const Color(0xFF1B5E20)
                                                        : const Color(0xFF075E54),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Created: ${_formatDate(year.createdAt)}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: (isEven 
                                                  ? const Color(0xFF4CAF50) 
                                                  : const Color(0xFF25D366)).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: _isLoadingDetails
                                                ? SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                        isEven
                                                            ? const Color(0xFF4CAF50)
                                                            : const Color(0xFF25D366),
                                                      ),
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: isEven
                                                        ? const Color(0xFF4CAF50)
                                                        : const Color(0xFF25D366),
                                                    size: 16,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "years_screen_add_year",
        onPressed: () async {
          // Navigate to AddYearScreen
          final newYear = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddYearScreen(
                eventName: widget.template.name,
                templateId: widget.template.id,
              ),
            ),
          );
          // Refresh the years list if a new year was added
          if (newYear != null) {
            setState(() {
              _yearsFuture = ref.read(yearServiceProvider).fetchYears();
            });
            
            // Navigate to AddEventScreen with the new year data
            if (newYear['createdYear'] != null && newYear['createdYear']['id'] != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddEventScreen(
                    yearId: newYear['createdYear']['id'],
                    templateId: widget.template.id,
                  ),
                ),
              );
            }
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Year'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }






  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
