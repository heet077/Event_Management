import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class YearSelectionDropdown extends StatefulWidget {
  final String? selectedYear;
  final Function(String?) onYearSelected;
  final String? hintText;
  final bool enabled;

  const YearSelectionDropdown({
    Key? key,
    this.selectedYear,
    required this.onYearSelected,
    this.hintText,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<YearSelectionDropdown> createState() => _YearSelectionDropdownState();
}

class _YearSelectionDropdownState extends State<YearSelectionDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  
  bool _isExpanded = false;
  String? _selectedYear;

  // Generate years from 2020 to 2030
  List<String> get _availableYears {
    final currentYear = DateTime.now().year;
    final years = <String>[];
    for (int i = currentYear - 5; i <= currentYear + 10; i++) {
      years.add(i.toString());
    }
    return years;
  }

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedYear;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;
    
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectYear(String year) {
    setState(() {
      _selectedYear = year;
      _isExpanded = false;
      _animationController.reverse();
    });
    widget.onYearSelected(year);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Button
        GestureDetector(
          onTap: _toggleDropdown,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.enabled
                    ? [
                        Colors.white,
                        Colors.grey.shade50,
                      ]
                    : [
                        Colors.grey.shade100,
                        Colors.grey.shade200,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
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
                color: _isExpanded
                    ? AppColors.primary
                    : Colors.grey.shade100,
                width: _isExpanded ? 2.5 : 1.5,
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.enabled
                          ? [
                              AppColors.primary.withOpacity(0.15),
                              AppColors.primary.withOpacity(0.08),
                            ]
                          : [
                              Colors.grey.shade300,
                              Colors.grey.shade400,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.enabled
                          ? AppColors.primary.withOpacity(0.2)
                          : Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.calendar_view_month,
                    color: widget.enabled ? AppColors.primary : Colors.grey.shade500,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Text
                Expanded(
                  child: Text(
                    _selectedYear ?? widget.hintText ?? 'Select Year',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedYear != null
                          ? AppColors.primary
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
                // Arrow Icon
                AnimatedBuilder(
                  animation: _rotateAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value * 3.14159,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.enabled ? AppColors.primary : Colors.grey.shade500,
                        size: 24,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        
        // Dropdown List
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                heightFactor: _expandAnimation.value,
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
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
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Add custom year option
                _buildCustomYearOption(),
                const Divider(height: 1, color: Colors.grey),
                // Year list
                ..._availableYears.map((year) => _buildYearItem(year)).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomYearOption() {
    return GestureDetector(
      onTap: () => _showCustomYearDialog(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add Custom Year',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearItem(String year) {
    final isSelected = _selectedYear == year;
    
    return GestureDetector(
      onTap: () => _selectYear(year),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                year,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.grey.shade700,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showCustomYearDialog() {
    final TextEditingController customYearController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Add Custom Year',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: customYearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Year',
                  hintText: 'e.g., 2025',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final customYear = customYearController.text.trim();
                if (customYear.isNotEmpty) {
                  Navigator.of(context).pop();
                  _selectYear(customYear);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
