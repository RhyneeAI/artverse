import 'package:flutter/material.dart';
import 'package:artverse/util/constants.dart';

/// ================= LABEL =================
class AuthLabel extends StatelessWidget {
  final String text;

  const AuthLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// ================= TEXT FIELD =================
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? labelText;
  final bool readOnly;
  final bool obscure;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.labelText,
    this.fillColor = AppColors.surface,
    this.readOnly = false,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.prefixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration( 
        labelText: labelText,
        hintText: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: false, 
        fillColor: fillColor, 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary), 
        ),
        hintStyle: TextStyle(color: AppColors.textSecondary),
      ),
      keyboardType: keyboardType,
      style: TextStyle(color: AppColors.textPrimary),
    );
  }
}

/// ================= BUTTON =================
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
