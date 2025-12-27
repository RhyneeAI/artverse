import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search',
    this.onFilterTap,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,

        // 🔍 icon kiri
        prefixIcon: const Icon(Icons.search),

        // 🎚️ icon filter kanan
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune),
          onPressed: onFilterTap,
        ),
      ),
    );
  }
}
