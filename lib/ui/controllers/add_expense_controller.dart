import 'package:flutter/material.dart';
import '../../../data/models/expense_model.dart';
import '../../../providers/expense_provider.dart';
import '../utils/toast_util.dart';

class AddExpenseController extends ChangeNotifier {
  final ExpenseModel? existing;

  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  String category = 'Food & Dining';
  DateTime date = DateTime.now();
  bool isIncome = false;
  bool isRecurring = false;

  AddExpenseController({this.existing}) {
    if (existing != null) {
      final e = existing!;
      titleCtrl.text = e.title;
      amountCtrl.text = e.amount.toStringAsFixed(0);
      notesCtrl.text = e.notes ?? '';
      category = e.category;
      date = e.date;
      isIncome = e.isIncome;
      isRecurring = e.isRecurring;
    }
  }

  void setCategory(String val) {
    if (category != val) {
      category = val;
      notifyListeners();
    }
  }

  void setDate(DateTime val) {
    if (date != val) {
      date = val;
      notifyListeners();
    }
  }

  void setIsIncome(bool val) {
    if (isIncome != val) {
      isIncome = val;
      notifyListeners();
    }
  }

  void setIsRecurring(bool val) {
    if (isRecurring != val) {
      isRecurring = val;
      notifyListeners();
    }
  }

  Future<void> save(BuildContext context, ExpenseProvider ep) async {
    if (titleCtrl.text.isEmpty || amountCtrl.text.isEmpty) {
      ToastUtil.show(context, 'Fill all required fields');
      return;
    }
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || amount <= 0) {
      ToastUtil.show(context, 'Enter a valid amount');
      return;
    }

    final expense = ExpenseModel(
      id: existing?.id ?? ep.createId(),
      title: titleCtrl.text.trim(),
      amount: amount,
      category: category,
      date: date,
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
      isIncome: isIncome,
      isRecurring: isRecurring,
    );

    if (existing != null) {
      await ep.updateExpense(expense);
    } else {
      await ep.addExpense(expense);
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    amountCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }
}
