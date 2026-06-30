import 'package:flutter/material.dart';
import '../../../data/models/category_model.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final List<CategoryModel> categories;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.value,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category_rounded),
      ),
      items: categories
          .map((c) => DropdownMenuItem(
                value: c.name,
                child: Row(
                  children: [
                    Icon(c.icon, size: 20),
                    const SizedBox(width: 8),
                    Text(c.name),
                  ],
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
