import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'shared_prefs_helper.dart';
import '../models/expense_model.dart';
import '../models/budget_model.dart';

class ExportService {
  static Future<String> exportToJson() async {
    final expenses = SharedPrefsHelper.getAllExpenses();
    final budgets = SharedPrefsHelper.getAllBudgets()
        .where((b) => b.month == DateTime.now().month && b.year == DateTime.now().year)
        .toList();

    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
      'expenses': expenses
          .map((e) => {
                'id': e.id,
                'title': e.title,
                'amount': e.amount,
                'category': e.category,
                'date': e.date.toIso8601String(),
                'isIncome': e.isIncome,
                'notes': e.notes,
                'isRecurring': e.isRecurring,
              })
          .toList(),
      'budgets': budgets
          .map((b) => {
                'id': b.id,
                'category': b.category,
                'limit': b.limit,
                'month': b.month,
                'year': b.year,
              })
          .toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(data);
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/expense_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(json);
    return file.path;
  }

  static Future<void> shareExport() async {
    final path = await exportToJson();
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(path)], text: 'SpendoraIQ Backup');
  }

  static Future<bool> importFromJson(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final expensesList = data['expenses'] as List<dynamic>;

      for (final e in expensesList) {
        final expense = ExpenseModel(
          id: e['id'],
          title: e['title'],
          amount: (e['amount'] as num).toDouble(),
          category: e['category'],
          date: DateTime.parse(e['date']),
          isIncome: e['isIncome'],
          notes: e['notes'],
          isRecurring: e['isRecurring'] ?? false,
        );
        await SharedPrefsHelper.addExpense(expense);
      }

      if (data['budgets'] != null) {
        final budgetsList = data['budgets'] as List<dynamic>;
        for (final b in budgetsList) {
          final budget = BudgetModel(
            id: b['id'],
            category: b['category'],
            limit: (b['limit'] as num).toDouble(),
            month: b['month'],
            year: b['year'],
          );
          await SharedPrefsHelper.saveBudget(budget);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
