import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/pie_chart_card.dart';
import '../widgets/bar_chart_card.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/section_header.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late AnalyticsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnalyticsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<ExpenseProvider>();
    final sp = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final catBreakdown = ep.categoryBreakdownForRange(
            _controller.startDate, _controller.endDate);
        final totalExpense =
            ep.expenseForRange(_controller.startDate, _controller.endDate);
        final monthly = ep.last6MonthsExpenses();

        return Scaffold(
          appBar: AppBar(title: const Text('Analytics')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Range Picker
                InkWell(
                  onTap: () => _controller.pickDateRange(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: cs.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_rounded, color: cs.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${DateFormat.yMMMd().format(_controller.startDate)}  -  ${DateFormat.yMMMd().format(_controller.endDate)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        const Icon(Icons.edit_calendar_rounded,
                            size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Pie Chart
                if (catBreakdown.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionHeader('Category Breakdown'),
                      Text(
                        sp.formatAmount(totalExpense),
                        style: TextStyle(
                          color: cs.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PieChartCard(
                    catBreakdown: catBreakdown,
                    touchedIndex: _controller.touchedIndex,
                    onTouch: _controller.setTouchedIndex,
                    sp: sp,
                  ),
                  const SizedBox(height: 24),
                ] else ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.pie_chart_outline_rounded,
                              size: 64,
                              color: cs.onSurface.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          Text('No expenses in this period',
                              style: TextStyle(
                                  color: cs.onSurface.withValues(alpha: 0.5))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Bar Chart - Monthly
                const SectionHeader('Monthly Spending (6 months)'),
                const SizedBox(height: 8),
                BarChartCard(monthly: monthly, sp: sp),
                const SizedBox(height: 16),

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}