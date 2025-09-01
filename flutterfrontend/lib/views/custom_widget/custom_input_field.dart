import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';
import '../../utils/responsive_text_style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleVisibility,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),
          labelText: label,
          labelStyle: ResponsiveTextStyle.body(context).copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),

          filled: true,
          fillColor: Colors.white.withOpacity(0.85),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.primary,
            ),
            onPressed: toggleVisibility,
          )
              : null,
        ),
      ),
    );
  }
}
