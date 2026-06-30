import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/category_model.dart';
import '../../providers/expense_provider.dart';
import '../controllers/manage_category_controller.dart';
import 'custom_bottom_sheet.dart';
import 'custom_text_field.dart';
import 'primary_button.dart';

class CategoryEditorSheet extends StatefulWidget {
  final CategoryModel? category;

  const CategoryEditorSheet({super.key, this.category});

  @override
  State<CategoryEditorSheet> createState() => _CategoryEditorSheetState();
}

class _CategoryEditorSheetState extends State<CategoryEditorSheet> {
  late ManageCategoryController _controller;

  static const _icons = [
    Icons.restaurant, Icons.directions_car, Icons.shopping_bag, Icons.sports_esports,
    Icons.medical_services, Icons.school, Icons.receipt_long, Icons.local_grocery_store,
    Icons.home, Icons.flight, Icons.spa, Icons.trending_up, Icons.attach_money,
    Icons.laptop_mac, Icons.category, Icons.pets, Icons.fitness_center, Icons.local_cafe,
    Icons.movie, Icons.music_note, Icons.build, Icons.child_friendly, Icons.card_giftcard,
    Icons.work, Icons.phone, Icons.water_drop, Icons.electric_bolt, Icons.wifi,
  ];

  static const _colors = [
    0xFFFF6B6B, 0xFF4ECDC4, 0xFFFFE66D, 0xFFA78BFA, 0xFF06D6A0, 0xFF118AB2,
    0xFFFF9F43, 0xFF26DE81, 0xFFFC5C65, 0xFF45AAF2, 0xFFFD9644, 0xFF20BF6B,
    0xFF95A5A6, 0xFFE84393, 0xFF00CEC9, 0xFF6C5CE7,
  ];

  @override
  void initState() {
    super.initState();
    _controller = ManageCategoryController();
    _controller.init(widget.category);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    final ep = context.watch<ExpenseProvider>();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomBottomSheet(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Category' : 'New Category',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
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
                      CustomTextField(
                        controller: _controller.nameCtrl,
                        autofocus: !isEditing,
                        labelText: 'Category Name',
                        prefixIcon: Icons.label_outline,
                      ),
                      const SizedBox(height: 24),
                      const Text('Select Color',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _colors.map((c) {
                          return GestureDetector(
                            onTap: () => _controller.setColor(c),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(c),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _controller.selectedColor == c
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: _controller.selectedColor == c
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text('Select Icon',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemCount: _icons.length,
                        itemBuilder: (context, index) {
                          final icon = _icons[index];
                          final isSelected = _controller.selectedIcon == icon;
                          return GestureDetector(
                            onTap: () => _controller.setIcon(icon),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Color(_controller.selectedColor)
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
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
                  child: PrimaryButton(
                    onPressed: () =>
                        _controller.save(context, ep, widget.category),
                    text: isEditing ? 'Update Category' : 'Create Category',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}