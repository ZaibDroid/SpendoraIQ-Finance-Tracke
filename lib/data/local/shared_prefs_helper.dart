import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';
import '../models/budget_model.dart';
import '../models/category_model.dart';

class SharedPrefsHelper {
  static const String expenseKey = 'expenses';
  static const String budgetKey = 'budgets';
  static const String settingsKey = 'settings';
  static const String categoryKey = 'categories';
  
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }


  // --- Categories ---
  static List<CategoryModel> getAllCategories() {
    final String? jsonStr = _prefs.getString(categoryKey);
    if (jsonStr == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveAllCategories(List<CategoryModel> categories) async {
    final String jsonStr = jsonEncode(categories.map((e) => e.toJson()).toList());
    await _prefs.setString(categoryKey, jsonStr);
  }

  // --- Expenses ---
  static List<ExpenseModel> getAllExpenses() {
    final String? jsonStr = _prefs.getString(expenseKey);
    if (jsonStr == null) return [];
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      final expenses = jsonList.map((e) => ExpenseModel.fromJson(e)).toList();
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    } catch (_) {
      return [];
    }
  }
  
  static Future<void> _saveAllExpenses(List<ExpenseModel> expenses) async {
    final String jsonStr = jsonEncode(expenses.map((e) => e.toJson()).toList());
    await _prefs.setString(expenseKey, jsonStr);
  }

  static Future<void> addExpense(ExpenseModel expense) async {
    final expenses = getAllExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index >= 0) {
      expenses[index] = expense;
    } else {
      expenses.add(expense);
    }
    await _saveAllExpenses(expenses);
  }

  static Future<void> updateExpense(ExpenseModel expense) async {
    await addExpense(expense);
  }

  static Future<void> deleteExpense(String id) async {
    final expenses = getAllExpenses();
    expenses.removeWhere((e) => e.id == id);
    await _saveAllExpenses(expenses);
  }

  // --- Budgets ---
  static List<BudgetModel> getAllBudgets() {
    final String? jsonStr = _prefs.getString(budgetKey);
    if (jsonStr == null) return [];
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList.map((e) => BudgetModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveAllBudgets(List<BudgetModel> budgets) async {
    final String jsonStr = jsonEncode(budgets.map((b) => b.toJson()).toList());
    await _prefs.setString(budgetKey, jsonStr);
  }

  static Future<void> saveBudget(BudgetModel budget) async {
    final budgets = getAllBudgets();
    final index = budgets.indexWhere((b) => b.id == budget.id);
    if (index >= 0) {
      budgets[index] = budget;
    } else {
      budgets.add(budget);
    }
    await _saveAllBudgets(budgets);
  }

  static Future<void> deleteBudget(String id) async {
    final budgets = getAllBudgets();
    budgets.removeWhere((b) => b.id == id);
    await _saveAllBudgets(budgets);
  }

  // --- Settings ---
  static Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString('${settingsKey}_$key', value);
    } else if (value is bool) {
      await _prefs.setBool('${settingsKey}_$key', value);
    } else if (value is int) {
      await _prefs.setInt('${settingsKey}_$key', value);
    } else if (value is double) {
      await _prefs.setDouble('${settingsKey}_$key', value);
    }
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    final fullKey = '${settingsKey}_$key';
    if (!_prefs.containsKey(fullKey)) return defaultValue;
    
    if (T == String) {
      return _prefs.getString(fullKey) as T?;
    } else if (T == bool) {
      return _prefs.getBool(fullKey) as T?;
    } else if (T == int) {
      return _prefs.getInt(fullKey) as T?;
    } else if (T == double) {
      return _prefs.getDouble(fullKey) as T?;
    }
    return defaultValue;
  }

  // --- Utility ---
  static Future<void> clearAllData() async {
    await _prefs.remove(expenseKey);
    await _prefs.remove(budgetKey);
    await _prefs.remove('${settingsKey}_hasOnboarded');
    await _prefs.remove('${settingsKey}_userName');
    await _prefs.remove('${settingsKey}_userContact');
    await _prefs.remove('${settingsKey}_userImagePath');
    await _prefs.remove('${settingsKey}_hasProfileSetup');
  }

  static Map<String, dynamic> exportData() {
    return {
      'userName': getSetting<String>('userName') ?? '',
      'expenses': getAllExpenses().map((e) => e.toJson()).toList(),
      'budgets': getAllBudgets().map((b) => b.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    };
  }

  static Future<void> importData(Map<String, dynamic> data) async {
    await clearAllData();
    if (data['expenses'] != null) {
      final expenses = (data['expenses'] as List)
          .map((e) => ExpenseModel.fromJson(e))
          .toList();
      await _saveAllExpenses(expenses);
    }
    if (data['budgets'] != null) {
      final budgets = (data['budgets'] as List)
          .map((b) => BudgetModel.fromJson(b))
          .toList();
      await _saveAllBudgets(budgets);
    }
  }
}
