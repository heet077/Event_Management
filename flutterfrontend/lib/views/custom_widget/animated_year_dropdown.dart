import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../models/year_model.dart';
import '../../providers/year_provider.dart';

class AnimatedYearDropdown extends ConsumerStatefulWidget {
  final String? selectedYear;
  final Function(String?) onYearSelected;
  final String? hintText;
  final bool enabled;

  const AnimatedYearDropdown({
    Key? key,
    this.selectedYear,
    required this.onYearSelected,
    this.hintText,
    this.enabled = true,
  }) : super(key: key);

  @override
  ConsumerState<AnimatedYearDropdown> createState() => _AnimatedYearDropdownState();
}

class _AnimatedYearDropdownState extends ConsumerState<AnimatedYearDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  
  bool _isExpanded = false;
  YearModel? _selectedYearModel;

  @override
  void initState() {
    super.initState();
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

    // Load years when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(yearProvider.notifier).fetchYears();
    });
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

  void _selectYear(YearModel year) {
    setState(() {
      _selectedYearModel = year;
      _isExpanded = false;
      _animationController.reverse();
    });
    widget.onYearSelected(year.yearName);
  }

  @override
  Widget build(BuildContext context) {
    final years = ref.watch(yearProvider);
    final isLoading = years.isEmpty;

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
              borderRadius: BorderRadius.circular(20),
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
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: _isExpanded
                    ? AppColors.primary
                    : Colors.grey.shade200,
                width: _isExpanded ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.enabled
                          ? AppColors.primary.withOpacity(0.2)
                          : Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: widget.enabled ? AppColors.primary : Colors.grey.shade500,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Text
                Expanded(
                  child: Text(
                    _selectedYearModel?.yearName ?? widget.hintText ?? 'Enter Year',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedYearModel != null
                          ? AppColors.primary
                          : Colors.grey.shade500,
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
              borderRadius: BorderRadius.circular(16),
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
                if (isLoading)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Loading years...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (years.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey.shade500,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'No years available',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...years.map((year) => _buildYearItem(year)).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYearItem(YearModel year) {
    final isSelected = _selectedYearModel?.id == year.id;
    
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
                year.yearName,
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
}
