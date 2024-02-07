
import 'package:flutter_social_sample_app/core/preferences/preference_interface.dart';
import 'package:flutter_social_sample_app/core/preferences/shared_preferences_manager.dart';

class PreferenceInterfaceImpl extends PreferenceInterface{

  SharedPreferencesManager? sharedPreferencesManager;

  
  PreferenceInterfaceImpl(){
    sharedPreferencesManager = SharedPreferencesManager();
  }



  @override
  Future<bool> isLoggedIn() async {
    return await sharedPreferencesManager?.getBool("isLoggedIn") ?? false ;
  }

  @override
  Future<String?> loggedInUserId() async {
    return await sharedPreferencesManager?.getString("loggedInUserId") ;
  }

  @override
  Future<bool?> setLoggedIn(bool isLoggedIn) async {
    return await sharedPreferencesManager?.setBool("isLoggedIn", isLoggedIn) ?? false ;
  }

  @override
  Future<bool?> setLoggedInUserId(String userId) async {
    return await sharedPreferencesManager?.setString("loggedInUserId", userId);
  }
  
  @override
  Future<String?> loggedInUserDisplayName() async {
    return await sharedPreferencesManager?.getString("displayName") ;
  }
  
  @override
  Future<bool?> setLoggedInUserDisplayName(String userDisplayName) async {
    return await sharedPreferencesManager?.setString("displayName", userDisplayName);
  }
  
  @override
  void removeAllPreference() async {
    sharedPreferencesManager?.remove("displayName");
    sharedPreferencesManager?.remove("loggedInUserId");
    sharedPreferencesManager?.remove("isLoggedIn");
  }

}