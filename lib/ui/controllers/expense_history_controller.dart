import 'package:flutter/material.dart';
import '../../../providers/expense_provider.dart';

class ExpenseHistoryController extends ChangeNotifier {
  final searchCtrl = TextEditingController();

  void onSearchChanged(String val, ExpenseProvider ep) {
    ep.setSearch(val);
  }

  void clearSearch(ExpenseProvider ep) {
    searchCtrl.clear();
    ep.setSearch('');
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}
