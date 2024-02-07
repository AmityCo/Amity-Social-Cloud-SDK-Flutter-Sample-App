abstract class PreferenceInterface{
  Future<bool?> isLoggedIn();
  Future<String?> loggedInUserId();
  Future<String?> loggedInUserDisplayName();
  Future<bool?> setLoggedIn( bool isLoggedIn );
  Future<bool?> setLoggedInUserId(String userId);
  Future<bool?> setLoggedInUserDisplayName(String userDisplayName);
  void removeAllPreference();
}