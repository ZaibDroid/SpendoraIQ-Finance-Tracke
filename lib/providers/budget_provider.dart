import 'package:flutter/foundation.dart';
import '../data/models/budget_model.dart';
import '../data/local/shared_prefs_helper.dart';

mixin BudgetProvider on ChangeNotifier {
  List<BudgetModel> _budgets = [];

  List<BudgetModel> get budgets => _budgets;

  void loadBudgets() {
    _budgets = SharedPrefsHelper.getAllBudgets();
  }

  Future<void> saveBudget(BudgetModel budget) async {
    await SharedPrefsHelper.saveBudget(budget);
    _budgets = SharedPrefsHelper.getAllBudgets();
    notifyListeners();
  }

  Future<void> deleteBudget(String id) async {
    await SharedPrefsHelper.deleteBudget(id);
    _budgets = SharedPrefsHelper.getAllBudgets();
    notifyListeners();
  }

  BudgetModel? getBudgetForCategory(String category, int month, int year) {
    try {
      return _budgets.firstWhere((b) =>
          b.category == category && b.month == month && b.year == year);
    } catch (_) {
      return null;
    }
  }
}
