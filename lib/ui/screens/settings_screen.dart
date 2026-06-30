import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/expense_provider.dart';
import 'help_screen.dart';
import 'privacy_policy_screen.dart';
import 'manage_categories_screen.dart';

import '../controllers/settings_view_controller.dart';
import '../widgets/theme_selector.dart';
import '../widgets/currency_picker_sheet.dart';
import '../widgets/profile_card.dart';
import '../widgets/section_header.dart';
import '../widgets/setting_card.dart';
import '../widgets/setting_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final ep = context.read<ExpenseProvider>();
    final controller = SettingsViewController();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProfileCard(sp: sp),
          const SizedBox(height: 24),

          // Appearance
          const SectionHeader('Appearance'),
          SettingCard(
            children: [
              ThemeSelector(sp: sp),
            ],
          ),
          const SizedBox(height: 12),

          // Preferences
          const SectionHeader('Preferences'),
          SettingCard(
            children: [
              SettingListTile(
                icon: Icons.currency_exchange_rounded,
                iconColor: Colors.green,
                title: 'Currency',
                subtitle: sp.currency,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CurrencyPickerSheet(sp: sp),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Data
          const SectionHeader('Data Management'),
          SettingCard(
            children: [
              SettingListTile(
                icon: Icons.upload_file_rounded,
                iconColor: Colors.blue,
                title: 'Export Data',
                subtitle: 'Save as JSON file',
                onTap: () => controller.exportData(context, ep),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                icon: Icons.category_rounded,
                iconColor: Colors.orange,
                title: 'Manage Categories',
                subtitle: 'Add, edit or delete categories',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageCategoriesScreen()));
                },
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                icon: Icons.delete_forever_rounded,
                iconColor: Colors.red,
                title: 'Reset All Data',
                subtitle: 'This cannot be undone',
                titleColor: Colors.red,
                onTap: () => controller.confirmReset(context, ep, sp),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Legal & Help
          const SectionHeader('Legal & Help'),
          SettingCard(
            children: [
              SettingListTile(
                icon: Icons.help_outline_rounded,
                iconColor: Colors.purple,
                title: 'Help & Support',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()));
                },
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: Colors.indigo,
                title: 'Privacy Policy',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
                },
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}