import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/monthly_overview_card.dart';
import '../widgets/budget_card.dart';
import '../controllers/add_budget_controller.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/primary_button.dart';

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
          ? EmptyStateWidget(
              icon: Icons.bar_chart_rounded,
              title: 'No budgets set',
              subtitle: 'Set budgets to track your spending',
              buttonText: 'Add Budget',
              onAction: () => _showAddBudget(context),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                MonthlyOverviewCard(ep: ep, sp: sp, now: now),
                const SizedBox(height: 16),
                Text(
                  'Category Budgets',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...budgets.map((b) => BudgetCard(
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

class _AddBudgetSheet extends StatefulWidget {
  const _AddBudgetSheet();

  @override
  State<_AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends State<_AddBudgetSheet> {
  late AddBudgetController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddBudgetController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<ExpenseProvider>();
    final cats = ep.categories;

    return CustomBottomSheet(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set Budget',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                CategoryDropdown(
                  value: _controller.category,
                  categories: cats,
                  onChanged: (v) => _controller.setCategory(v!),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _controller.amountCtrl,
                  keyboardType: TextInputType.number,
                  labelText: 'Budget Limit',
                  prefixIcon: Icons.account_balance_wallet_rounded,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  onPressed: () => _controller.save(context, ep),
                  text: 'Save Budget',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}