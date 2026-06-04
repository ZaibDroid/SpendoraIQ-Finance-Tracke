import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/category_model.dart';
import '../../providers/expense_provider.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final _uuid = const Uuid();

  void _showCategoryDialog([CategoryModel? category]) {
    final isEditing = category != null;
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    IconData selectedIcon = category?.icon ?? Icons.category;
    int selectedColor = category?.color ?? 0xFF4ECDC4;

    final icons = [
      Icons.restaurant, Icons.directions_car, Icons.shopping_bag, Icons.sports_esports,
      Icons.medical_services, Icons.school, Icons.receipt_long, Icons.local_grocery_store,
      Icons.home, Icons.flight, Icons.spa, Icons.trending_up, Icons.attach_money,
      Icons.laptop_mac, Icons.category, Icons.pets, Icons.fitness_center, Icons.local_cafe,
      Icons.movie, Icons.music_note, Icons.build, Icons.child_friendly, Icons.card_giftcard,
      Icons.work, Icons.phone, Icons.water_drop, Icons.electric_bolt, Icons.wifi,
    ];

    final colors = [
      0xFFFF6B6B, 0xFF4ECDC4, 0xFFFFE66D, 0xFFA78BFA, 0xFF06D6A0, 0xFF118AB2,
      0xFFFF9F43, 0xFF26DE81, 0xFFFC5C65, 0xFF45AAF2, 0xFFFD9644, 0xFF20BF6B,
      0xFF95A5A6, 0xFFE84393, 0xFF00CEC9, 0xFF6C5CE7,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? 'Edit Category' : 'New Category',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameCtrl,
                          autofocus: !isEditing,
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
                            prefixIcon: Icon(Icons.label_outline),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Select Color', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: colors.map((c) {
                            return GestureDetector(
                              onTap: () => setModalState(() => selectedColor = c),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(c),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedColor == c ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: selectedColor == c ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        const Text('Select Icon', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: icons.length,
                          itemBuilder: (context, index) {
                            final icon = icons[index];
                            final isSelected = selectedIcon == icon;
                            return GestureDetector(
                              onTap: () => setModalState(() => selectedIcon = icon),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected ? Color(selectedColor) : Theme.of(context).colorScheme.surfaceContainerHighest,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty) return;
                        final newCat = CategoryModel(
                          id: isEditing ? category.id : _uuid.v4(),
                          name: nameCtrl.text.trim(),
                          icon: selectedIcon,
                          color: selectedColor,
                          isCustom: true,
                        );
                        if (isEditing) {
                          context.read<ExpenseProvider>().updateCategory(newCat);
                        } else {
                          context.read<ExpenseProvider>().addCategory(newCat);
                        }
                        Navigator.pop(ctx);
                      },
                      child: Text(isEditing ? 'Update Category' : 'Create Category'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
          ? const Center(child: Text('No categories available'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(cat.color).withValues(alpha: 0.2),
                    child: Icon(cat.icon, color: Color(cat.color)),
                  ),
                  title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: cat.isCustom ? const Text('Custom') : const Text('Default'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                        onPressed: () => _showCategoryDialog(cat),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Category?'),
                              content: const Text('Existing expenses using this category will fall back to "Other".'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    context.read<ExpenseProvider>().deleteCategory(cat.id);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
        onPressed: () => _showCategoryDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Category'),
      ),
    );
  }
}
