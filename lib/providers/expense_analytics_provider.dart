import '../data/models/expense_model.dart';

mixin ExpenseAnalyticsProvider {
  List<ExpenseModel> get expenses;

  double get totalBalance {
    final income = expenses
        .where((e) => e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
    final expense = expenses
        .where((e) => !e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
    return income - expense;
  }

  double monthlyExpense(int month, int year) {
    return expenses
        .where((e) =>
            !e.isIncome && e.date.month == month && e.date.year == year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double monthlyIncome(int month, int year) {
    return expenses
        .where(
            (e) => e.isIncome && e.date.month == month && e.date.year == year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, double> categoryBreakdownForRange(DateTime start, DateTime end) {
    final map = <String, double>{};
    for (var e in expenses.where((e) {
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
    return expenses.where((e) {
      if (e.isIncome) return false;
      final eDate = DateTime(e.date.year, e.date.month, e.date.day);
      final sDate = DateTime(start.year, start.month, start.day);
      final eEnd = DateTime(end.year, end.month, end.day);
      return !eDate.isBefore(sDate) && !eDate.isAfter(eEnd);
    }).fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, double> categoryBreakdown(int month, int year) {
    final map = <String, double>{};
    for (var e in expenses.where((e) =>
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

  double budgetUsed(String category, int month, int year) {
    return expenses
        .where((e) =>
            !e.isIncome &&
            e.category == category &&
            e.date.month == month &&
            e.date.year == year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  List<ExpenseModel> get recentExpenses => expenses.take(5).toList();
}
