import 'package:flutter/material.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/category_model.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/app_utils.dart';

class ExpenseHeroCard extends StatelessWidget {
  final ExpenseModel expense;
  final SettingsProvider sp;
  final List<CategoryModel> categories;

  const ExpenseHeroCard({
    super.key,
    required this.expense,
    required this.sp,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: expense.isIncome
              ? [const Color(0xFF11998e), const Color(0xFF38ef7d)]
              : [cs.primary, cs.primary.withBlue(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                AppUtils.getCategoryIcon(expense.category, categories),
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            expense.title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '${expense.isIncome ? '+' : '-'}${sp.formatAmountFull(expense.amount)}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
