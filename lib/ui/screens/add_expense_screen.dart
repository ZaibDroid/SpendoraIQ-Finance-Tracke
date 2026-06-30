import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense_model.dart';
import '../../providers/expense_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/app_utils.dart';
import '../widgets/transaction_type_tab_bar.dart';
import '../widgets/amount_input_card.dart';
import '../controllers/add_expense_controller.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class AddExpenseScreen extends StatefulWidget {
  final ExpenseModel? existing;
  const AddExpenseScreen({super.key, this.existing});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AddExpenseController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddExpenseController(existing: widget.existing);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _controller.isIncome ? 1 : 0,
    );
    _tabController.addListener(() {
      _controller.setIsIncome(_tabController.index == 1);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _controller.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) _controller.setDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sp = context.read<SettingsProvider>();
    final ep = context.watch<ExpenseProvider>();
    final cats = ep.categories;

    return CustomBottomSheet(
      height: MediaQuery.of(context).size.height * 0.92,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.existing != null
                          ? 'Edit Transaction'
                          : 'Add Transaction',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded)),
                  ],
                ),
              ),
              TransactionTypeTabBar(controller: _tabController),
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      AmountInputCard(
                        controller: _controller.amountCtrl,
                        isIncome: _controller.isIncome,
                        currencySymbol: sp.currencySymbol,
                      ),
                      const SizedBox(height: 16),
                      // Title
                      CustomTextField(
                        controller: _controller.titleCtrl,
                        autofocus: true,
                        labelText: 'Title *',
                        hintText: 'e.g. Burger King, Uber ride...',
                        prefixIcon: Icons.edit_rounded,
                      ),
                      const SizedBox(height: 12),
                      // Category
                      CategoryDropdown(
                        value: _controller.category,
                        categories: cats,
                        onChanged: (v) => _controller.setCategory(v!),
                      ),
                      const SizedBox(height: 12),
                      // Date
                      CustomListTile(
                        icon: Icons.calendar_today_rounded,
                        title: AppUtils.formatDate(_controller.date),
                        trailing: Icon(Icons.chevron_right_rounded,
                            color: cs.onSurface.withValues(alpha: 0.4)),
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 12),
                      // Notes
                      CustomTextField(
                        controller: _controller.notesCtrl,
                        maxLines: 2,
                        labelText: 'Notes (optional)',
                        prefixIcon: Icons.notes_rounded,
                      ),
                      const SizedBox(height: 12),
                      // Recurring Toggle
                      CustomListTile(
                        icon: Icons.repeat_rounded,
                        title: 'Recurring',
                        trailing: Switch.adaptive(
                          value: _controller.isRecurring,
                          onChanged: _controller.setIsRecurring,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Save Button
                      PrimaryButton(
                        onPressed: () => _controller.save(context, ep),
                        backgroundColor: _controller.isIncome
                            ? const Color(0xFF11998e)
                            : cs.primary,
                        text: widget.existing != null
                            ? 'Update Transaction'
                            : 'Save Transaction',
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}