import 'package:flutter/material.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';

class MonthlyOverviewCard extends StatelessWidget {
  final ExpenseProvider ep;
  final SettingsProvider sp;
  final DateTime now;
  
  const MonthlyOverviewCard({
    super.key,
    required this.ep,
    required this.sp,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totalBudget = ep.budgets
        .where((b) => b.month == now.month && b.year == now.year)
        .fold(0.0, (s, b) => s + b.limit);
    final totalSpent = ep.monthlyExpense(now.month, now.year);
    final ratio = totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;
    final isOver = totalSpent > totalBudget && totalBudget > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOver
              ? [const Color(0xFFFF5252), const Color(0xFFFF1744)]
              : [cs.primary, cs.primary.withBlue(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Overview',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sp.formatAmountFull(totalSpent),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '/ ${sp.formatAmountFull(totalBudget)}',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7), fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: AlwaysStoppedAnimation<Color>(
                  isOver ? Colors.yellow : Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOver
                ? '⚠️ Over budget by ${sp.formatAmount(totalSpent - totalBudget)}'
                : '✅ ${sp.formatAmount(totalBudget - totalSpent)} remaining',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
