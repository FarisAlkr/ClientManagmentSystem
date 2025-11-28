import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings state
class SettingsState {
  final bool isDarkMode;
  final String language;
  final bool isLoading;

  const SettingsState({
    this.isDarkMode = false,
    this.language = 'he',
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? language,
    bool? isLoading,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  static const String _darkModeKey = 'dark_mode';
  static const String _languageKey = 'language';

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      final language = prefs.getString(_languageKey) ?? 'he';

      state = SettingsState(
        isDarkMode: isDarkMode,
        language: language,
      );
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> toggleDarkMode() async {
    try {
      final newValue = !state.isDarkMode;
      state = state.copyWith(isDarkMode: newValue);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, newValue);
    } catch (e) {
      print('Error saving dark mode setting: $e');
    }
  }

  Future<void> setLanguage(String language) async {
    try {
      state = state.copyWith(language: language);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
    } catch (e) {
      print('Error saving language setting: $e');
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true);
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// Providers
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

// Individual setting providers for easier consumption
final isDarkModeProvider = StateNotifierProvider<_BoolNotifier, bool>((ref) {
  return _BoolNotifier();
});

final currentLanguageProvider = StateNotifierProvider<_StringNotifier, String>((ref) {
  return _StringNotifier();
});

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Helper notifiers
class _BoolNotifier extends StateNotifier<bool> {
  _BoolNotifier() : super(false) {
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool('dark_mode') ?? false;
    } catch (e) {
      print('Error loading dark mode: $e');
    }
  }

  Future<void> toggle() async {
    try {
      state = !state;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dark_mode', state);
    } catch (e) {
      print('Error saving dark mode: $e');
    }
  }
}

class _StringNotifier extends StateNotifier<String> {
  _StringNotifier() : super('he') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getString('language') ?? 'he';
    } catch (e) {
      print('Error loading language: $e');
    }
  }

  Future<void> setLanguage(String language) async {
    try {
      state = language;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', language);
    } catch (e) {
      print('Error saving language: $e');
    }
  }
}