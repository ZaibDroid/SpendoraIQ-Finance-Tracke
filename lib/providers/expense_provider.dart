import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/models/expense_model.dart';
import '../data/local/shared_prefs_helper.dart';

import 'expense_analytics_provider.dart';
import 'expense_filter_provider.dart';
import 'budget_provider.dart';
import 'category_provider.dart';

class ExpenseProvider extends ChangeNotifier
    with
        ExpenseAnalyticsProvider,
        ExpenseFilterProvider,
        BudgetProvider,
        CategoryProvider {
  List<ExpenseModel> _expenses = [];

  final _uuid = const Uuid();

  @override
  List<ExpenseModel> get expenses => _expenses;

  @override
  List<ExpenseModel> get rawExpenses => _expenses;

  void loadData() {
    _expenses = SharedPrefsHelper.getAllExpenses();
    loadBudgets();
    loadCategories();
    notifyListeners();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await SharedPrefsHelper.addExpense(expense);
    _expenses = SharedPrefsHelper.getAllExpenses();
    notifyListeners();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await SharedPrefsHelper.updateExpense(expense);
    _expenses = SharedPrefsHelper.getAllExpenses();
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await SharedPrefsHelper.deleteExpense(id);
    _expenses = SharedPrefsHelper.getAllExpenses();
    notifyListeners();
  }

  String createId() => _uuid.v4();

  Future<void> clearAllData() async {
    await SharedPrefsHelper.clearAllData();
    loadData();
  }

  Map<String, dynamic> exportData() => SharedPrefsHelper.exportData();

  Future<void> importData(Map<String, dynamic> data) async {
    await SharedPrefsHelper.importData(data);
    loadData();
  }
}
