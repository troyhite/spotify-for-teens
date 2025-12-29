import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/content_filter.dart';

class ParentalControlsService extends ChangeNotifier {
  final SharedPreferences _prefs;
  
  static const String _filterKey = 'content_filter';
  static const String _pinKey = 'parental_pin';

  ParentalControlsService(this._prefs);

  /// Get current content filter
  ContentFilter get currentFilter {
    final filterJson = _prefs.getString(_filterKey);
    if (filterJson != null) {
      try {
        return ContentFilter.fromJson(json.decode(filterJson));
      } catch (e) {
        debugPrint('Error loading filter: $e');
      }
    }
    return ContentFilter.defaultFilter;
  }

  /// Update content filter
  Future<void> setFilter(ContentFilter filter) async {
    await _prefs.setString(_filterKey, json.encode(filter.toJson()));
    notifyListeners();
  }

  /// Check if PIN is set
  bool get isPinSet {
    return _prefs.getString(_pinKey) != null;
  }

  /// Set parental control PIN
  Future<void> setPin(String pin) async {
    if (pin.length != 4) {
      throw ArgumentError('PIN must be 4 digits');
    }
    await _prefs.setString(_pinKey, pin);
    notifyListeners();
  }

  /// Verify PIN
  bool verifyPin(String pin) {
    return _prefs.getString(_pinKey) == pin;
  }

  /// Clear PIN
  Future<void> clearPin() async {
    await _prefs.remove(_pinKey);
    notifyListeners();
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    await setFilter(ContentFilter.defaultFilter);
    await clearPin();
  }
}
