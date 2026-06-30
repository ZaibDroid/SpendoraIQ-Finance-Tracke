import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import 'custom_bottom_sheet.dart';

class CategoryFilterSheet extends StatelessWidget {
  const CategoryFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<ExpenseProvider>();
    final cs = Theme.of(context).colorScheme;

    return CustomBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Category',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ep.categories.map((c) {
                final selected = ep.filterCategory == c.name;
                return GestureDetector(
                  onTap: () {
                    ep.setFilterCategory(selected ? null : c.name);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? cs.primary : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(c.icon,
                            size: 14, color: selected ? Colors.white : null),
                        const SizedBox(width: 6),
                        Text(
                          c.name,
                          style: TextStyle(
                              fontSize: 12,
                              color: selected ? Colors.white : null),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                ep.clearFilters();
                Navigator.pop(context);
              },
              child: const Text('Clear All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}