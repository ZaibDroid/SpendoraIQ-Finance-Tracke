import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/models/expense_model.dart';
import '../data/models/budget_model.dart';
import '../data/models/category_model.dart';
import '../data/local/shared_prefs_helper.dart';

class ExpenseProvider extends ChangeNotifier {
  List<ExpenseModel> _expenses = [];
  List<BudgetModel> _budgets = [];
  List<CategoryModel> _categories = [];
  String _searchQuery = '';
  String? _filterCategory;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  bool _showIncomeOnly = false;
  bool _showExpenseOnly = false;

  final _uuid = const Uuid();

  List<ExpenseModel> get expenses => _expenses;
  List<BudgetModel> get budgets => _budgets;
  List<CategoryModel> get categories => _categories;
  String get searchQuery => _searchQuery;
  String? get filterCategory => _filterCategory;

  List<ExpenseModel> get filteredExpenses {
    var result = _expenses.where((e) {
      if (_searchQuery.isNotEmpty &&
          !e.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !(e.notes?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false)) {
        return false;
      }
      if (_filterCategory != null && e.category != _filterCategory) {
        return false;
      }
      if (_filterStartDate != null && e.date.isBefore(_filterStartDate!)) {
        return false;
      }
      if (_filterEndDate != null &&
          e.date.isAfter(_filterEndDate!.add(const Duration(days: 1)))) {
        return false;
      }
      if (_showIncomeOnly && !e.isIncome) return false;
      if (_showExpenseOnly && e.isIncome) return false;
      return true;
    }).toList();
    return result;
  }

  void loadData() {
    _expenses = SharedPrefsHelper.getAllExpenses();
    _budgets = SharedPrefsHelper.getAllBudgets();
    _categories = SharedPrefsHelper.getAllCategories();
    if (_categories.isEmpty) {
      _categories = List.from(CategoryModel.defaultCategories);
      SharedPrefsHelper.saveAllCategories(_categories);
    }
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

  Future<void> saveBudget(BudgetModel budget) async {
    await SharedPrefsHelper.saveBudget(budget);
    _budgets = SharedPrefsHelper.getAllBudgets();
    _categories = SharedPrefsHelper.getAllCategories();
    if (_categories.isEmpty) {
      _categories = List.from(CategoryModel.defaultCategories);
      SharedPrefsHelper.saveAllCategories(_categories);
    }
    notifyListeners();
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

  Future<void> deleteBudget(String id) async {
    await SharedPrefsHelper.deleteBudget(id);
    _budgets = SharedPrefsHelper.getAllBudgets();
    _categories = SharedPrefsHelper.getAllCategories();
    if (_categories.isEmpty) {
      _categories = List.from(CategoryModel.defaultCategories);
      SharedPrefsHelper.saveAllCategories(_categories);
    }
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterCategory(String? category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setDateFilter(DateTime? start, DateTime? end) {
    _filterStartDate = start;
    _filterEndDate = end;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterCategory = null;
    _filterStartDate = null;
    _filterEndDate = null;
    _showIncomeOnly = false;
    _showExpenseOnly = false;
    notifyListeners();
  }

  // ─── Analytics ──────────────────────────────────────────────────────────
  double get totalBalance {
    final income = _expenses
        .where((e) => e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
    final expense = _expenses
        .where((e) => !e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
    return income - expense;
  }

  double monthlyExpense(int month, int year) {
    return _expenses
        .where((e) =>
            !e.isIncome && e.date.month == month && e.date.year == year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double monthlyIncome(int month, int year) {
    return _expenses
        .where(
            (e) => e.isIncome && e.date.month == month && e.date.year == year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }


  Map<String, double> categoryBreakdownForRange(DateTime start, DateTime end) {
    final map = <String, double>{};
    for (var e in _expenses.where((e) {
      if (e.isIncome) return false;
      final eDate = DateTime(e.date.year, e.date.month, e.date.day);
      final sDate = DateTime(start.year, start.month, start.day);
      final eEnd = DateTime(end.year, end.month, end.day);
      return !eDate.isBefore(sDate) && !eDate.isAfter(eEnd);
    })) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  double expenseForRange(DateTime start, DateTime end) {
    return _expenses.where((e) {
      if (e.isIncome) return false;
      final eDate = DateTime(e.date.year, e.date.month, e.date.day);
      final sDate = DateTime(start.year, start.month, start.day);
      final eEnd = DateTime(end.year, end.month, end.day);
      return !eDate.isBefore(sDate) && !eDate.isAfter(eEnd);
    }).fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, double> categoryBreakdown(int month, int year) {
    final map = <String, double>{};
    for (var e in _expenses.where((e) =>
        !e.isIncome && e.date.month == month && e.date.year == year)) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  List<MapEntry<int, double>> last6MonthsExpenses() {
    final now = DateTime.now();
    final result = <MapEntry<int, double>>[];
    for (int i = 5; i >= 0; i--) {
      final dt = DateTime(now.year, now.month - i, 1);
      result.add(MapEntry(dt.month, monthlyExpense(dt.month, dt.year)));
    }
    return result;
  }

  BudgetModel? getBudgetForCategory(String category, int month, int year) {
    try {
      return _budgets.firstWhere((b) =>
          b.category == category && b.month == month && b.year == year);
    } catch (_) {
      return null;
    }
  }

  double budgetUsed(String category, int month, int year) {
    return _expenses
        .where((e) =>
            !e.isIncome &&
            e.category == category &&
            e.date.month == month &&
            e.date.year == year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }



  List<ExpenseModel> get recentExpenses => _expenses.take(5).toList();

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
