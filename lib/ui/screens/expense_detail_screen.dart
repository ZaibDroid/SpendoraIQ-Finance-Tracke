import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense_model.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/app_utils.dart';
import 'add_expense_screen.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final ExpenseModel expense;
  final bool isEditing;

  const ExpenseDetailScreen(
      {super.key, required this.expense, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SettingsProvider>();
    final ep = context.read<ExpenseProvider>();
    final cs = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => AddExpenseScreen(existing: expense),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_rounded, color: cs.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Transaction'),
                  content: const Text(
                      'Are you sure you want to delete this transaction?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Delete',
                            style: TextStyle(color: cs.error))),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await ep.deleteExpense(expense.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero amount card
            Container(
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
                        AppUtils.getCategoryIcon(expense.category, context.watch<ExpenseProvider>().categories),
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
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.category_rounded,
                    label: 'Category',
                    value: expense.category,
                  ),
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: AppUtils.formatDate(expense.date),
                  ),
                  _DetailRow(
                    icon: Icons.swap_vert_rounded,
                    label: 'Type',
                    value: expense.isIncome ? 'Income' : 'Expense',
                    valueColor:
                        expense.isIncome ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
                  ),
                  if (expense.isRecurring)
                    _DetailRow(
                      icon: Icons.repeat_rounded,
                      label: 'Recurring',
                      value: 'Yes',
                      valueColor: cs.primary,
                    ),
                  if (expense.notes != null && expense.notes!.isNotEmpty)
                    _DetailRow(
                      icon: Icons.notes_rounded,
                      label: 'Notes',
                      value: expense.notes!,
                    ),
                  _DetailRow(
                    icon: Icons.tag_rounded,
                    label: 'ID',
                    value: expense.id.substring(0, 8).toUpperCase(),
                    valueColor: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.5))),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
