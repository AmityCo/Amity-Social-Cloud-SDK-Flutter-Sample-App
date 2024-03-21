import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final SharedPreferencesManager _instance = SharedPreferencesManager._internal();
 
 final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
SharedPreferences? prefs;

  factory SharedPreferencesManager() {
    return _instance;
  }
  
  
  SharedPreferencesManager._internal(){
    setup ();
  } 

  Future<void> setup () async {
    prefs = await _prefs;
    print("prefs: $prefs");
  }
  
  Future<bool> setString(String key, String value) async {
    if(prefs == null) setup();
    return await prefs!.setString(key, value);
  }

  Future<bool?> setBool(String key, bool value) async {
    if(prefs == null) setup();
    return prefs?.setBool(key, value);
  }

  Future<bool?> setInt(String key, int value) async {
    if(prefs == null) setup();
    return prefs?.setInt(key, value);
  }

  Future<bool> getBool(String key) async {
    if(prefs == null) await setup();
    return prefs?.getBool(key) ?? false;
  }

  Future<String> getString(String key) async {
    if(prefs == null) setup();
    return prefs?.getString(key) ?? "";
  }

  Future<int> getInt(String key) async {
    if(prefs == null) setup();
    return prefs?.getInt(key) ?? 0;
  }

  void remove(String key) async {
    if(prefs == null) setup();
     await prefs?.remove(key);
  }


  

}