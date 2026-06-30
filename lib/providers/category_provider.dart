import 'package:flutter/foundation.dart';
import '../data/models/category_model.dart';
import '../data/local/shared_prefs_helper.dart';

mixin CategoryProvider on ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  void loadCategories() {
    _categories = SharedPrefsHelper.getAllCategories();
    if (_categories.isEmpty) {
      _categories = List.from(CategoryModel.defaultCategories);
      SharedPrefsHelper.saveAllCategories(_categories);
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    _categories.add(category);
    await SharedPrefsHelper.saveAllCategories(_categories);
    notifyListeners();
  }

  Future<void> updateCategory(CategoryModel category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
      await SharedPrefsHelper.saveAllCategories(_categories);
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
    await SharedPrefsHelper.saveAllCategories(_categories);
    notifyListeners();
  }
}
