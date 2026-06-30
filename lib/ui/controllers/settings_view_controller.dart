import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/expense_provider.dart';
import '../utils/toast_util.dart';
import '../screens/onboarding_screen.dart';

class SettingsViewController {
  Future<void> exportData(BuildContext context, ExpenseProvider ep) async {
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

  Future<void> confirmReset(BuildContext context, ExpenseProvider ep, SettingsProvider sp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text(
            'This will permanently delete all your transactions and budgets. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reset', style: TextStyle(color: Colors.red))),
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
