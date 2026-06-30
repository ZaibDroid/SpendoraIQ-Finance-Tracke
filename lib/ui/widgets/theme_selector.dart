import 'package:flutter/material.dart';
import '../../../providers/settings_provider.dart';
import 'custom_icon_box.dart';

class ThemeSelector extends StatelessWidget {
  final SettingsProvider sp;

  const ThemeSelector({super.key, required this.sp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CustomIconBox(
                  icon: Icons.palette_rounded,
                  color: Colors.deepPurple,
                  size: 34,
                  iconSize: 18,
                  shape: BoxShape.rectangle),
              SizedBox(width: 12),
              Text('Theme',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ThemeOption(
                label: 'Light',
                selected: sp.themeMode == ThemeMode.light,
                onTap: () => sp.setThemeMode(ThemeMode.light),
              ),
              const SizedBox(width: 8),
              _ThemeOption(
                label: 'Dark',
                selected: sp.themeMode == ThemeMode.dark,
                onTap: () => sp.setThemeMode(ThemeMode.dark),
              ),
              const SizedBox(width: 8),
              _ThemeOption(
                label: 'System',
                selected: sp.themeMode == ThemeMode.system,
                onTap: () => sp.setThemeMode(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : cs.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}