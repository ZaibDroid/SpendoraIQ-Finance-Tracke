import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';
import '../models/budget_model.dart';
import '../models/category_model.dart';
import 'generic_list_storage.dart';

class SharedPrefsHelper {
  static const String expenseKey = 'expenses';
  static const String budgetKey = 'budgets';
  static const String settingsKey = 'settings';
  static const String categoryKey = 'categories';
  
  static late SharedPreferences _prefs;

  // Generic Storage Instances
  static final _categoryStorage = GenericListStorage<CategoryModel>(
    key: categoryKey,
    fromJson: (json) => CategoryModel.fromJson(json),
    toJson: (cat) => cat.toJson(),
  );

  static final _expenseStorage = GenericListStorage<ExpenseModel>(
    key: expenseKey,
    fromJson: (json) => ExpenseModel.fromJson(json),
    toJson: (exp) => exp.toJson(),
  );

  static final _budgetStorage = GenericListStorage<BudgetModel>(
    key: budgetKey,
    fromJson: (json) => BudgetModel.fromJson(json),
    toJson: (bud) => bud.toJson(),
  );

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Categories ---
  static List<CategoryModel> getAllCategories() => _categoryStorage.getAll(_prefs);
  
  static Future<void> saveAllCategories(List<CategoryModel> categories) => 
      _categoryStorage.saveAll(_prefs, categories);

  // --- Expenses ---
  static List<ExpenseModel> getAllExpenses() {
    final expenses = _expenseStorage.getAll(_prefs);
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  static Future<void> addExpense(ExpenseModel expense) => 
      _expenseStorage.saveItem(_prefs, expense, (e) => e.id == expense.id);

  static Future<void> updateExpense(ExpenseModel expense) => addExpense(expense);

  static Future<void> deleteExpense(String id) => 
      _expenseStorage.deleteItem(_prefs, (e) => e.id == id);

  // --- Budgets ---
  static List<BudgetModel> getAllBudgets() => _budgetStorage.getAll(_prefs);

  static Future<void> saveBudget(BudgetModel budget) => 
      _budgetStorage.saveItem(_prefs, budget, (b) => b.id == budget.id);

  static Future<void> deleteBudget(String id) => 
      _budgetStorage.deleteItem(_prefs, (b) => b.id == id);

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
      await _expenseStorage.saveAll(_prefs, expenses);
    }
    if (data['budgets'] != null) {
      final budgets = (data['budgets'] as List)
          .map((b) => BudgetModel.fromJson(b))
          .toList();
      await _budgetStorage.saveAll(_prefs, budgets);
    }
  }
}
