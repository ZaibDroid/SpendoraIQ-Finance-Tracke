import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/expense_tile.dart';
import '../widgets/dashboard_header.dart';
import 'expense_history_screen.dart';
import '../widgets/empty_state_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<ExpenseProvider>();
    final sp = context.watch<SettingsProvider>();
    final now = DateTime.now();
    final monthExp = ep.monthlyExpense(now.month, now.year);
    final monthInc = ep.monthlyIncome(now.month, now.year);
    final balance = ep.totalBalance;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DashboardHeader(
            sp: sp,
            balance: balance,
            monthInc: monthInc,
            monthExp: monthExp,
          ),
          
          // Recent Transactions Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ExpenseHistoryScreen())),
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),

          if (ep.recentExpenses.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: EmptyStateWidget(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'No transactions yet',
                  subtitle: 'Tap + to add your first expense',
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ExpenseTile(expense: ep.recentExpenses[i]),
                ),
                childCount: ep.recentExpenses.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}