import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/budget_model.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<ExpenseProvider>();
    final sp = context.watch<SettingsProvider>();
    final now = DateTime.now();
    final budgets = ep.budgets
        .where((b) => b.month == now.month && b.year == now.year)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddBudget(context),
          ),
        ],
      ),
      body: budgets.isEmpty
          ? _EmptyBudget(onAdd: () => _showAddBudget(context))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _MonthlyOverview(ep: ep, sp: sp, now: now),
                const SizedBox(height: 16),
                Text(
                  'Category Budgets',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...budgets.map((b) => _BudgetCard(
                    budget: b,
                    ep: ep,
                    sp: sp,
                    now: now)),
                const SizedBox(height: 80),
              ],
            ),
    );
  }

  void _showAddBudget(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddBudgetSheet(),
    );
  }
}

class _MonthlyOverview extends StatelessWidget {
  final ExpenseProvider ep;
  final SettingsProvider sp;
  final DateTime now;
  const _MonthlyOverview(
      {required this.ep, required this.sp, required this.now});

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

class _BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final ExpenseProvider ep;
  final SettingsProvider sp;
  final DateTime now;
  const _BudgetCard(
      {required this.budget,
      required this.ep,
      required this.sp,
      required this.now});

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
                _catIcon(budget.category, context),
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

  IconData _catIcon(String category, BuildContext context) {
    return context.watch<ExpenseProvider>().categories
            .where((c) => c.name == category)
            .firstOrNull
            ?.icon ??
        Icons.category;
  }
}

class _EmptyBudget extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyBudget({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart_rounded, size: 64),
          const SizedBox(height: 16),
          Text('No budgets set',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Set budgets to track your spending',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Budget'),
          ),
        ],
      ),
    );
  }
}

class _AddBudgetSheet extends StatefulWidget {
  const _AddBudgetSheet();

  @override
  State<_AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends State<_AddBudgetSheet> {
  final _amountCtrl = TextEditingController();
  String _category = 'Food & Dining';

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) return;
    final now = DateTime.now();
    final budget = BudgetModel(
      id: const Uuid().v4(),
      category: _category,
      limit: amount,
      month: now.month,
      year: now.year,
    );
    await context.read<ExpenseProvider>().saveBudget(budget);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cats = context.watch<ExpenseProvider>().categories;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text('Set Budget',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category_rounded),
            ),
            items: cats
                .map((c) => DropdownMenuItem(
                      value: c.name,
                      child: Row(children: [
                        Icon(c.icon),
                        const SizedBox(width: 8),
                        Text(c.name)
                      ]),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Budget Limit',
              prefixIcon: Icon(Icons.account_balance_wallet_rounded),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Save Budget',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
