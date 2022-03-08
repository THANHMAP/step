import 'package:shared_preferences/shared_preferences.dart';

class SPref {
  static final SPref instance = SPref._internal();

  SPref._internal();

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future set(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  dynamic get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  addStringToSF(String key, String def) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, def);
  }

  addIntToSF(String key, int def) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, def);
  }

  addBoolToSF(String key, bool def) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, def);
  }

  getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool(key);
    return boolValue;
  }

  getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.getInt(key);
    return intValue;
  }


}
