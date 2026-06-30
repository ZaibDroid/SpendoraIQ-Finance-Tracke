import 'package:flutter/material.dart';
import '../../data/models/budget_model.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';

class BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final ExpenseProvider ep;
  final SettingsProvider sp;
  final DateTime now;
  
  const BudgetCard({
    super.key,
    required this.budget,
    required this.ep,
    required this.sp,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final used = ep.budgetUsed(budget.category, budget.month, budget.year);
    final ratio = budget.limit > 0 ? (used / budget.limit).clamp(0.0, 1.0) : 0.0;
    final isOver = used > budget.limit;
    final progressColor = isOver
        ? const Color(0xFFFF5252)
        : ratio > 0.8
            ? const Color(0xFFFF9800)
            : const Color(0xFF4CAF50);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _catIcon(budget.category, ep.categories),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(budget.category,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(
                      '${sp.formatAmount(used)} / ${sp.formatAmount(budget.limit)}',
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isOver ? 'Over!' : '${(ratio * 100).toInt()}%',
                  style: TextStyle(
                      color: progressColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    size: 18, color: cs.error),
                onPressed: () => ep.deleteBudget(budget.id),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: cs.onSurface.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  IconData _catIcon(String category, List<dynamic> categories) {
    return categories
            .where((c) => c.name == category)
            .firstOrNull
            ?.icon ??
        Icons.category;
  }
}
