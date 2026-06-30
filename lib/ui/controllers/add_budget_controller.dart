import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/budget_model.dart';
import '../../../providers/expense_provider.dart';

class AddBudgetController extends ChangeNotifier {
  final amountCtrl = TextEditingController();
  String category = 'Food & Dining';

  void setCategory(String val) {
    if (category != val) {
      category = val;
      notifyListeners();
    }
  }

  Future<void> save(BuildContext context, ExpenseProvider ep) async {
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || amount <= 0) return;
    final now = DateTime.now();
    final budget = BudgetModel(
      id: const Uuid().v4(),
      category: category,
      limit: amount,
      month: now.month,
      year: now.year,
    );
    await ep.saveBudget(budget);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }
}
