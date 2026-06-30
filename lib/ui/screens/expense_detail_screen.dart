import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense_model.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/app_utils.dart';
import '../widgets/expense_hero_card.dart';
import '../widgets/expense_detail_row.dart';
import 'add_expense_screen.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final ExpenseModel expense;
  final bool isEditing;

  const ExpenseDetailScreen(
      {super.key, required this.expense, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final ep = context.watch<ExpenseProvider>();
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
            ExpenseHeroCard(
              expense: expense,
              sp: sp,
              categories: ep.categories,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ExpenseDetailRow(
                    icon: Icons.category_rounded,
                    label: 'Category',
                    value: expense.category,
                  ),
                  ExpenseDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: AppUtils.formatDate(expense.date),
                  ),
                  ExpenseDetailRow(
                    icon: Icons.swap_vert_rounded,
                    label: 'Type',
                    value: expense.isIncome ? 'Income' : 'Expense',
                    valueColor:
                        expense.isIncome ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
                  ),
                  if (expense.isRecurring)
                    ExpenseDetailRow(
                      icon: Icons.repeat_rounded,
                      label: 'Recurring',
                      value: 'Yes',
                      valueColor: cs.primary,
                    ),
                  if (expense.notes != null && expense.notes!.isNotEmpty)
                    ExpenseDetailRow(
                      icon: Icons.notes_rounded,
                      label: 'Notes',
                      value: expense.notes!,
                    ),
                  ExpenseDetailRow(
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