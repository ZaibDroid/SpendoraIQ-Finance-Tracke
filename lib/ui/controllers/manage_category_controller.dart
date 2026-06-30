import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/category_model.dart';
import '../../../providers/expense_provider.dart';

class ManageCategoryController extends ChangeNotifier {
  final nameCtrl = TextEditingController();
  IconData selectedIcon = Icons.category;
  int selectedColor = 0xFF4ECDC4;
  final _uuid = const Uuid();

  void init(CategoryModel? category) {
    nameCtrl.text = category?.name ?? '';
    selectedIcon = category?.icon ?? Icons.category;
    selectedColor = category?.color ?? 0xFF4ECDC4;
  }

  void setIcon(IconData icon) {
    if (selectedIcon != icon) {
      selectedIcon = icon;
      notifyListeners();
    }
  }

  void setColor(int color) {
    if (selectedColor != color) {
      selectedColor = color;
      notifyListeners();
    }
  }

  void save(BuildContext context, ExpenseProvider ep, CategoryModel? existingCategory) {
    if (nameCtrl.text.trim().isEmpty) return;
    
    final isEditing = existingCategory != null;
    final newCat = CategoryModel(
      id: isEditing ? existingCategory.id : _uuid.v4(),
      name: nameCtrl.text.trim(),
      icon: selectedIcon,
      color: selectedColor,
      isCustom: true,
    );

    if (isEditing) {
      ep.updateCategory(newCat);
    } else {
      ep.addCategory(newCat);
    }
    
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }
}
