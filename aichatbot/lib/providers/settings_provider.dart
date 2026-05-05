import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_model.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  UserPlan _plan = UserPlan.free;
  String _selectedModelId = 'gpt55';
  bool _voiceEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  UserPlan get plan => _plan;
  String get selectedModelId => _selectedModelId;
  AIModel get selectedModel => AIModel.byId(_selectedModelId);
  bool get voiceEnabled => _voiceEnabled;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool('darkMode') ?? false;
    _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    _selectedModelId = prefs.getString('selectedModel') ?? 'gpt55';
    _plan = UserPlan.values.firstWhere(
      (p) => p.name == (prefs.getString('plan') ?? 'free'),
      orElse: () => UserPlan.free,
    );
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    notifyListeners();
  }

  Future<void> selectModel(String id) async {
    _selectedModelId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedModel', id);
    notifyListeners();
  }

  Future<void> upgradePlan(UserPlan plan) async {
    _plan = plan;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('plan', plan.name);
    notifyListeners();
  }

  void setVoiceEnabled(bool v) {
    _voiceEnabled = v;
    notifyListeners();
  }
}
