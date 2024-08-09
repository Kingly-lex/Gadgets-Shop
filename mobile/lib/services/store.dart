import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  const Store._();

  static const String _tokenKey = 'Tokens';

// set tokens
  static Future<void> setTokens(Map tokens) async {
    // clear();
    String encoded = jsonEncode(tokens);
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_tokenKey, encoded);
  }

// get saved user tokens
  static Future<Map?> getToken() async {
    final preferences = await SharedPreferences.getInstance();

    final data = preferences.getString(_tokenKey);

    if (data == null || data.isEmpty) {
      return null;
    }

    return jsonDecode(data);
  }

// clear saved tokens
  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static const String _savedEmail = 'Email';

// set email from user
  static Future<void> setEmail(String email) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_savedEmail, email);
  }

  // get saved email
  static Future<String?> getEmail() async {
    final preferences = await SharedPreferences.getInstance();

    final data = preferences.getString(_savedEmail);

    if (data == null || data.isEmpty) {
      return null;
    }

    return data;
  }

  // clear saved email
  static Future<void> removeEmail() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_savedEmail);
  }
}
