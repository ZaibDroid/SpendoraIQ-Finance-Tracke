import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/app_utils.dart';

class BarChartCard extends StatelessWidget {
  final List<MapEntry<int, double>> monthly;
  final SettingsProvider sp;
  
  const BarChartCard({
    super.key,
    required this.monthly,
    required this.sp,
  });

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
