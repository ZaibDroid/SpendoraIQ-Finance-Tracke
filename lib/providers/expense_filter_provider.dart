import 'package:flutter/foundation.dart';
import '../data/models/expense_model.dart';

mixin ExpenseFilterProvider on ChangeNotifier {
  String _searchQuery = '';
  String? _filterCategory;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  bool _showIncomeOnly = false;
  bool _showExpenseOnly = false;

  String get searchQuery => _searchQuery;
  String? get filterCategory => _filterCategory;

  /// Subclasses must provide access to the raw list of expenses
  List<ExpenseModel> get rawExpenses;

  List<ExpenseModel> get filteredExpenses {
    var result = rawExpenses.where((e) {
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
}
