import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/local/shared_prefs_helper.dart';
import 'providers/expense_provider.dart';
import 'providers/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.initialize();
  final hasOnboarded = SharedPrefsHelper.getSetting<bool>('hasOnboarded', defaultValue: false) ?? false;
  runApp(SmartExpenseApp(hasOnboarded: hasOnboarded));
}

class SmartExpenseApp extends StatelessWidget {
  final bool hasOnboarded;
  const SmartExpenseApp({super.key, required this.hasOnboarded});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..loadSettings()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..loadData()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (_, sp, __) => MaterialApp(
          title: 'SpendoraIQ',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: sp.themeMode,
          home: hasOnboarded ? const SplashScreen() : const OnboardingScreen(),
        ),
      ),
    );
  }
}
