import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/app_utils.dart';


class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _touchedIndex = -1;
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  Future<void> _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _touchedIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<ExpenseProvider>();
    final sp = context.watch<SettingsProvider>();
    final catBreakdown = ep.categoryBreakdownForRange(_startDate, _endDate);
    final totalExpense = ep.expenseForRange(_startDate, _endDate);
    final monthly = ep.last6MonthsExpenses();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Picker
            InkWell(
              onTap: () => _pickDateRange(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, color: cs.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${DateFormat.yMMMd().format(_startDate)}  -  ${DateFormat.yMMMd().format(_endDate)}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    const Icon(Icons.edit_calendar_rounded, size: 20, color: Colors.grey),
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
                  const _SectionTitle('Category Breakdown'),
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
              _PieChartCard(
                catBreakdown: catBreakdown,
                touchedIndex: _touchedIndex,
                onTouch: (i) => setState(() => _touchedIndex = i),
                sp: sp,
              ),
              const SizedBox(height: 24),
            ] else ...[
               Center(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 40),
                   child: Column(
                     children: [
                       Icon(Icons.pie_chart_outline_rounded, size: 64, color: cs.onSurface.withValues(alpha: 0.2)),
                       const SizedBox(height: 16),
                       Text('No expenses in this period', style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5))),
                     ],
                   ),
                 ),
               ),
               const SizedBox(height: 24),
            ],

            // Bar Chart - Monthly
            const _SectionTitle('Monthly Spending (6 months)'),
            const SizedBox(height: 8),
            _BarChartCard(monthly: monthly, sp: sp),
            const SizedBox(height: 16),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      );
}



class _PieChartCard extends StatelessWidget {
  final Map<String, double> catBreakdown;
  final int touchedIndex;
  final Function(int) onTouch;
  final SettingsProvider sp;

  const _PieChartCard({
    required this.catBreakdown,
    required this.touchedIndex,
    required this.onTouch,
    required this.sp,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final entries = catBreakdown.entries.toList();
    final total = entries.fold(0.0, (s, e) => s + e.value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, resp) {
                    if (event is FlTapUpEvent) {
                      onTouch(resp?.touchedSection?.touchedSectionIndex ?? -1);
                    }
                  },
                ),
                sections: List.generate(entries.length, (i) {
                  final isTouched = i == touchedIndex;
                  final entry = entries[i];
                  final color = AppUtils.getCategoryColor(entry.key, context.watch<ExpenseProvider>().categories);
                  return PieChartSectionData(
                    value: entry.value,
                    color: color,
                    radius: isTouched ? 65 : 55,
                    title: '${(entry.value / total * 100).toStringAsFixed(0)}%',
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  );
                }),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: entries.map((e) {
              final color = AppUtils.getCategoryColor(e.key, context.watch<ExpenseProvider>().categories);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(e.key,
                      style: const TextStyle(fontSize: 11)),
                  const SizedBox(width: 4),
                  Text(sp.formatAmount(e.value),
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _BarChartCard extends StatelessWidget {
  final List<MapEntry<int, double>> monthly;
  final SettingsProvider sp;
  const _BarChartCard({required this.monthly, required this.sp});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: monthly.asMap().entries.map((e) {
              return BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value.value,
                    color: cs.primary,
                    width: 20,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6)),
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) => Text(
                    AppUtils.getMonthName(monthly[v.toInt()].key),
                    style: TextStyle(
                        fontSize: 10,
                        color: cs.onSurface.withValues(alpha: 0.6)),
                  ),
                ),
              ),
            ),
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(
                  color: cs.onSurface.withValues(alpha: 0.05), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}


