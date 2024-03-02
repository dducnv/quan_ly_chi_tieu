import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  Future<bool> saveData(String key, Object value) async {
    final prefHelper = await SharedPreferences.getInstance();
    try {
      final savedData = json.encode(value);
      return prefHelper.setString(key, savedData);
    } catch (e) {
      return Future<bool>.value(true);
    }
  }

  Future<dynamic> readData(String key) async {
    final prefHelper = await SharedPreferences.getInstance();
    final value = prefHelper.getString(key);
    if (value == null || value.isEmpty) {
      return null;
    } else {
      return json.decode(value);
    }
  }

  Future<bool> saveBool(String key, bool value) async {
    final prefHelper = await SharedPreferences.getInstance();
    try {
      return prefHelper.setBool(key, value);
    } catch (e) {
      return Future<bool>.value(true);
    }
  }

  Future<bool?> readBool(String key) async {
    final prefHelper = await SharedPreferences.getInstance();
    return prefHelper.getBool(key);
  }

  Future<bool?> saveString(String key, String value) async {
    final prefHelper = await SharedPreferences.getInstance();
    try {
      return prefHelper.setString(key, value);
    } catch (e) {
      return null;
    }
  }

  Future<String?> readString(String key) async {
    final prefHelper = await SharedPreferences.getInstance();
    return prefHelper.getString(key);
  }

  //save int

  Future<bool?> saveInt(String key, int value) async {
    final prefHelper = await SharedPreferences.getInstance();
    try {
      return prefHelper.setInt(key, value);
    } catch (e) {
      return null;
    }
  }

  //read int
  Future<int?> readInt(String key) async {
    final prefHelper = await SharedPreferences.getInstance();
    return prefHelper.getInt(key);
  }

  Future<bool?> removeData(String key) async {
    try {
      final prefHelper = await SharedPreferences.getInstance();
      return prefHelper.remove(key);
    } catch (e) {
      return Future<bool>.value(false);
    }
  }
}
