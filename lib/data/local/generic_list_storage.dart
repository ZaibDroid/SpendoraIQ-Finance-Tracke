import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GenericListStorage<T> {
  final String key;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  GenericListStorage({
    required this.key,
    required this.fromJson,
    required this.toJson,
  });

  List<T> getAll(SharedPreferences prefs) {
    final String? jsonStr = prefs.getString(key);
    if (jsonStr == null) return [];
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAll(SharedPreferences prefs, List<T> items) async {
    final String jsonStr = jsonEncode(items.map((e) => toJson(e)).toList());
    await prefs.setString(key, jsonStr);
  }

  Future<void> saveItem(SharedPreferences prefs, T item, bool Function(T) match) async {
    final items = getAll(prefs);
    final index = items.indexWhere(match);
    if (index >= 0) {
      items[index] = item;
    } else {
      items.add(item);
    }
    await saveAll(prefs, items);
  }

  Future<void> deleteItem(SharedPreferences prefs, bool Function(T) match) async {
    final items = getAll(prefs);
    items.removeWhere(match);
    await saveAll(prefs, items);
  }
}
