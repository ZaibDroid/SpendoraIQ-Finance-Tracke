import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/category_model.dart';
import '../../providers/expense_provider.dart';
import '../widgets/category_editor_sheet.dart';
import '../widgets/custom_icon_box.dart';
import '../widgets/empty_state_widget.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  void _showCategoryDialog(BuildContext context, [CategoryModel? category]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryEditorSheet(category: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ExpenseProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: categories.isEmpty
          ? EmptyStateWidget(
              icon: Icons.category_outlined,
              title: 'No categories available',
              subtitle: 'Create a new category to get started',
              buttonText: 'New Category',
              onAction: () => _showCategoryDialog(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  leading: CustomIconBox(
                    icon: cat.icon,
                    color: Color(cat.color),
                    opacity: 0.2,
                    size: 40,
                  ),
                  title: Text(cat.name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: cat.isCustom
                      ? const Text('Custom')
                      : const Text('Default'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: Colors.grey),
                        onPressed: () => _showCategoryDialog(context, cat),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Category?'),
                              content: const Text(
                                  'Existing expenses using this category will fall back to "Other".'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<ExpenseProvider>()
                                        .deleteCategory(cat.id);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Category'),
      ),
    );
  }
}