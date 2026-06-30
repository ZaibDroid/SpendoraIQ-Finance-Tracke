import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/app_utils.dart';

class PieChartCard extends StatelessWidget {
  final Map<String, double> catBreakdown;
  final int touchedIndex;
  final Function(int) onTouch;
  final SettingsProvider sp;

  const PieChartCard({
    super.key,
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
                  final color = AppUtils.getCategoryColor(
                      entry.key, context.watch<ExpenseProvider>().categories);
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
              final color = AppUtils.getCategoryColor(
                  e.key, context.watch<ExpenseProvider>().categories);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(e.key, style: const TextStyle(fontSize: 11)),
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
