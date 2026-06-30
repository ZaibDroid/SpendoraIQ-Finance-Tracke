import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/expense_provider.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/main_screen.dart';

class SplashController {
  Future<void> initApp(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4));
    if (!context.mounted) return;
    
    context.read<SettingsProvider>().loadSettings();
    context.read<ExpenseProvider>().loadData();
    
    if (!context.mounted) return;
    final hasProfile = context.read<SettingsProvider>().hasProfileSetup;
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            hasProfile ? const MainScreen() : const ProfileSetupScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
