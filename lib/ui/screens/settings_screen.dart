import 'dart:io';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../utils/toast_util.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/expense_provider.dart';
import 'profile_setup_screen.dart';
import 'help_screen.dart';
import 'privacy_policy_screen.dart';
import 'onboarding_screen.dart';
import 'manage_categories_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final ep = context.read<ExpenseProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  backgroundImage: sp.userImagePath != null ? FileImage(File(sp.userImagePath!)) : null,
                  child: sp.userImagePath == null ? Icon(Icons.person_rounded, size: 32, color: Theme.of(context).colorScheme.primary) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sp.userName.isNotEmpty ? sp.userName : 'User Profile', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(sp.userContact.isNotEmpty ? sp.userContact : 'Set up your profile', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen(isEditing: true)));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appearance
          const _SectionHeader('Appearance'),
          _SettingCard(
            children: [
              _ThemeTile(sp: sp),
            ],
          ),
          const SizedBox(height: 12),

          // Preferences
          const _SectionHeader('Preferences'),
          _SettingCard(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.currency_exchange_rounded, size: 18),
                ),
                title: const Text('Currency'),
                subtitle: Text(sp.currency),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showCurrencyPicker(context, sp),
              ),

            ],
          ),
          const SizedBox(height: 12),

          // Data
          const _SectionHeader('Data Management'),
          _SettingCard(
            children: [
              ListTile(
                leading: iconBox(Icons.upload_file_rounded, Colors.blue),
                title: const Text('Export Data'),
                subtitle: const Text('Save as JSON file'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _exportData(context, ep),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: iconBox(Icons.category_rounded, Colors.orange),
                title: const Text('Manage Categories'),
                subtitle: const Text('Add, edit or delete categories'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageCategoriesScreen()));
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: iconBox(Icons.delete_forever_rounded, Colors.red),
                title: const Text('Reset All Data',
                    style: TextStyle(color: Colors.red)),
                subtitle: const Text('This cannot be undone'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _confirmReset(context, ep, sp),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Legal & Help
          const _SectionHeader('Legal & Help'),
          _SettingCard(
            children: [
              ListTile(
                leading: iconBox(Icons.help_outline_rounded, Colors.purple),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()));
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: iconBox(Icons.privacy_tip_outlined, Colors.indigo),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right_rounded),
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

  Widget iconBox(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18),
    );
  }

  void _showCurrencyPicker(BuildContext context, SettingsProvider sp) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
                        Navigator.pop(_);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, ExpenseProvider ep) async {
    try {
      final data = ep.exportData();
      final String jsonStr = jsonEncode(data);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/smart_expense_backup.json');
      await file.writeAsString(jsonStr);
      if (context.mounted) {
        // ignore: deprecated_member_use
        await Share.shareXFiles([XFile(file.path)], text: 'My SpendoraIQ Backup');
      }
    } catch (e) {
      if (context.mounted) {
        ToastUtil.show(context, 'Export failed: $e');
      }
    }
  }

  Future<void> _confirmReset(
      BuildContext context, ExpenseProvider ep, SettingsProvider sp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text(
            'This will permanently delete all your transactions and budgets. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(_, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(_, true),
              child: const Text('Reset',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ep.clearAllData();
      sp.resetProfile();
      if (context.mounted) {
        ToastUtil.show(context, 'All data has been cleared.');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          (route) => false,
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingCard({required this.children});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
        return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(children: children),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final SettingsProvider sp;
  const _ThemeTile({required this.sp});

  @override
  Widget build(BuildContext context) {
        return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.palette_rounded, size: 18),
              ),
              const SizedBox(width: 12),
              const Text('Theme',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15)),
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
  const _ThemeOption(
      {required this.label,
      required this.selected,
      required this.onTap});

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
