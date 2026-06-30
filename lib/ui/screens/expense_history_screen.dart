import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../widgets/expense_tile.dart';
import '../widgets/category_filter_sheet.dart';
import '../controllers/expense_history_controller.dart';
import '../widgets/empty_state_widget.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});
  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  late ExpenseHistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpenseHistoryController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<ExpenseProvider>();
    final cs = Theme.of(context).colorScheme;
    final filtered = ep.filteredExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilter(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: CustomTextField(
              controller: _controller.searchCtrl,
              onChanged: (val) => _controller.onSearchChanged(val, ep),
              hintText: 'Search transactions...',
              prefixIcon: Icons.search_rounded,
                suffixIcon: ep.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => _controller.clearSearch(ep),
                      )
                    : null,
            ),
          ),
          if (ep.filterCategory != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(ep.filterCategory!,
                            style: TextStyle(
                                fontSize: 12, color: cs.primary)),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => ep.setFilterCategory(null),
                          child: Icon(Icons.close_rounded,
                              size: 14, color: cs.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: filtered.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.search_off_rounded,
                    title: 'No transactions found',
                    subtitle: 'Try adjusting your search or filters',
                    buttonText: (ep.searchQuery.isNotEmpty || ep.filterCategory != null)
                        ? 'Clear filters'
                        : null,
                    buttonIcon: Icons.clear_all_rounded,
                    onAction: ep.clearFilters,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => ExpenseTile(expense: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const CategoryFilterSheet(),
    );
  }
}