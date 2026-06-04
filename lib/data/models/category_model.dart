import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final int color;
  bool isFavorite;
  bool isCustom;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isFavorite = false,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconFontPackage': icon.fontPackage,
      'color': color,
      'isFavorite': isFavorite,
      'isCustom': isCustom,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: IconData(
        json['iconCodePoint'],
        fontFamily: json['iconFontFamily'],
        fontPackage: json['iconFontPackage'],
      ),
      color: json['color'],
      isFavorite: json['isFavorite'] ?? false,
      isCustom: json['isCustom'] ?? false,
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    int? color,
    bool? isFavorite,
    bool? isCustom,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isFavorite: isFavorite ?? this.isFavorite,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  static List<CategoryModel> defaultCategories = [
    CategoryModel(id: 'cat_01', name: 'Food & Dining', icon: Icons.restaurant, color: 0xFFFF6B6B),
    CategoryModel(id: 'cat_02', name: 'Transport', icon: Icons.directions_car, color: 0xFF4ECDC4),
    CategoryModel(id: 'cat_03', name: 'Shopping', icon: Icons.shopping_bag, color: 0xFFFFE66D),
    CategoryModel(id: 'cat_04', name: 'Entertainment', icon: Icons.sports_esports, color: 0xFFA78BFA),
    CategoryModel(id: 'cat_05', name: 'Health', icon: Icons.medical_services, color: 0xFF06D6A0),
    CategoryModel(id: 'cat_06', name: 'Education', icon: Icons.school, color: 0xFF118AB2),
    CategoryModel(id: 'cat_07', name: 'Bills & Utilities', icon: Icons.receipt_long, color: 0xFFFF9F43),
    CategoryModel(id: 'cat_08', name: 'Groceries', icon: Icons.local_grocery_store, color: 0xFF26de81),
    CategoryModel(id: 'cat_09', name: 'Rent & Housing', icon: Icons.home, color: 0xFFfc5c65),
    CategoryModel(id: 'cat_10', name: 'Travel', icon: Icons.flight, color: 0xFF45aaf2),
    CategoryModel(id: 'cat_11', name: 'Personal Care', icon: Icons.spa, color: 0xFFfd9644),
    CategoryModel(id: 'cat_12', name: 'Investment', icon: Icons.trending_up, color: 0xFF20bf6b),
    CategoryModel(id: 'cat_13', name: 'Salary', icon: Icons.attach_money, color: 0xFF26de81),
    CategoryModel(id: 'cat_14', name: 'Freelance', icon: Icons.laptop_mac, color: 0xFF4ECDC4),
    CategoryModel(id: 'cat_15', name: 'Other', icon: Icons.category, color: 0xFF95A5A6),
  ];
}
