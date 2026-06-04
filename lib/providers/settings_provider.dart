import 'package:flutter/material.dart';
import '../data/local/shared_prefs_helper.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _currency = 'PKR';
  bool _notificationsEnabled = true;
  String _currencySymbol = 'Rs.';
  String _userName = '';
  String _userContact = '';
  String? _userImagePath;
  bool _hasProfileSetup = false;

  ThemeMode get themeMode => _themeMode;
  String get currency => _currency;
  bool get notificationsEnabled => _notificationsEnabled;
  String get currencySymbol => _currencySymbol;
  String get userName => _userName;
  String get userContact => _userContact;
  String? get userImagePath => _userImagePath;
  bool get hasProfileSetup => _hasProfileSetup;

  static const Map<String, String> currencySymbols = {
    'PKR': 'Rs.',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'AED': 'AED',
    'SAR': 'SAR',
    'INR': '₹',
    'CAD': 'CA\$',
    'AUD': 'A\$',
  };

  void loadSettings() {
    final themeModeStr =
        SharedPrefsHelper.getSetting<String>('themeMode', defaultValue: 'system') ??
            'system';
    _themeMode = themeModeStr == 'light'
        ? ThemeMode.light
        : themeModeStr == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
    _currency =
        SharedPrefsHelper.getSetting<String>('currency', defaultValue: 'PKR') ??
            'PKR';
    _notificationsEnabled = SharedPrefsHelper.getSetting<bool>(
            'notifications', defaultValue: true) ??
        true;
    _currencySymbol = currencySymbols[_currency] ?? 'Rs.';
    _userName = SharedPrefsHelper.getSetting<String>('userName', defaultValue: '') ?? '';
    _userContact = SharedPrefsHelper.getSetting<String>('userContact', defaultValue: '') ?? '';
    _userImagePath = SharedPrefsHelper.getSetting<String>('userImagePath');
    _hasProfileSetup = SharedPrefsHelper.getSetting<bool>('hasProfileSetup', defaultValue: false) ?? false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await SharedPrefsHelper.saveSetting('themeMode',
        mode == ThemeMode.light ? 'light' : mode == ThemeMode.dark ? 'dark' : 'system');
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _currency = currency;
    _currencySymbol = currencySymbols[currency] ?? 'Rs.';
    await SharedPrefsHelper.saveSetting('currency', currency);
    notifyListeners();
  }

  Future<void> setNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    await SharedPrefsHelper.saveSetting('notifications', enabled);
    notifyListeners();
  }

  
  Future<void> saveProfile({required String name, required String contact, String? imagePath}) async {
    _userName = name;
    _userContact = contact;
    _userImagePath = imagePath;
    _hasProfileSetup = true;
    await SharedPrefsHelper.saveSetting('userName', name);
    await SharedPrefsHelper.saveSetting('userContact', contact);
    if (imagePath != null) await SharedPrefsHelper.saveSetting('userImagePath', imagePath);
    await SharedPrefsHelper.saveSetting('hasProfileSetup', true);
    notifyListeners();
  }

  
  void resetProfile() {
    _userName = '';
    _userContact = '';
    _userImagePath = null;
    _hasProfileSetup = false;
    notifyListeners();
  }

  String formatAmount(double amount) {
    if (amount >= 1000000) {
      return '$_currencySymbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$_currencySymbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '$_currencySymbol${amount.toStringAsFixed(0)}';
  }

  String formatAmountFull(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '$_currencySymbol$formatted';
  }
}
