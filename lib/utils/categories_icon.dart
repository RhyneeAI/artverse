import 'package:flutter/material.dart';

class CategoryUtils {
  static final Map<String, IconData> icons = {
    'computer': Icons.computer,
    'palette': Icons.palette,
    'draw': Icons.draw,
    'camera_alt': Icons.camera_alt,
    'layers': Icons.layers,
    'category': Icons.category,
    'brush': Icons.brush,
    'photo_camera': Icons.photo_camera,
    'format_paint': Icons.format_paint,
    'desktop_windows': Icons.desktop_windows,
    'camera': Icons.camera,
    'image': Icons.image,
    'terrain': Icons.terrain,
    'account_balance': Icons.account_balance,
    'more_horiz': Icons.more_horiz,
    'apps': Icons.apps,
  };

  static IconData getIcon(String iconName) {
    return icons[iconName] ?? Icons.category;
  }
}