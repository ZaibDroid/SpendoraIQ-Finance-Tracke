import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/category_model.dart';

class AppUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String getMonthName(int month) {
    return DateFormat('MMM').format(DateTime(2024, month));
  }

  static Color getCategoryColor(String category, List<CategoryModel> categories) {
    final cat = categories
        .where((c) => c.name == category)
        .firstOrNull;
    return Color(cat?.color ?? 0xFF95A5A6);
  }

  static IconData getCategoryIcon(String category, List<CategoryModel> categories) {
    final cat = categories
        .where((c) => c.name == category)
        .firstOrNull;
    return cat?.icon ?? Icons.category;
  }

}
