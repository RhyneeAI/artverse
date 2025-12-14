import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1D61E7); // #1D61E7
  static const Color secondary = Color(0xFF9E9E9E); // Colors.grey[500] equivalent
  static const Color background = Colors.white;
  static const Color textPrimary = Colors.white;
  static const Color textPrimary2 = Colors.black;
  static const Color textSecondary = Color(0xFF757575); // Colors.grey[600]
  static const Color error = Colors.red;
}

InputDecoration customInputDecoration({
  required String labelText,
  String? hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    filled: true,
    fillColor: AppColors.background,
    // Style minimalis dengan rounded + hanya garis bawah saat fokus
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  );
}