import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import 'custom_bottom_sheet.dart';

class CurrencyPickerSheet extends StatelessWidget {
  final SettingsProvider sp;

  const CurrencyPickerSheet({super.key, required this.sp});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Currency',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: SettingsProvider.currencySymbols.entries.map((e) {
                  final selected = sp.currency == e.key;
                  return ListTile(
                    leading: Text(e.value,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    title: Text(e.key),
                    subtitle: Text(e.value),
                    trailing: selected
                        ? Icon(Icons.check_circle_rounded,
                            color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () {
                      sp.setCurrency(e.key);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}