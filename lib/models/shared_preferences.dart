import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  static const String keyUsername = "username";
  static const String keyUserEmail = "useremail";
  static const String keyUserLoggedIn = "isloggedin";
  static const String keyUserSessionToken = "usersessiontoken";
  static const String keyUserRole = "userroletoken";

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  String get username => _sharedPrefs.getString(keyUsername) ?? "";

  set username(String value) {
    _sharedPrefs.setString(keyUsername, value);
  }

  String get useremail => _sharedPrefs.getString(keyUserEmail) ?? "";

  set useremail(String value) {
    _sharedPrefs.setString(keyUserEmail, value);
  }

  String get userrole => _sharedPrefs.getString(keyUserRole) ?? "";

  set userrole(String value) {
    _sharedPrefs.setString(keyUserRole, value);
  }

  String get usersessiontoken => _sharedPrefs.getString(keyUserSessionToken) ?? "";

  set usersessiontoken(String value) {
    _sharedPrefs.setString(keyUserSessionToken, value);
  }

  bool get isloggedin => _sharedPrefs.getBool(keyUserLoggedIn) ?? false;

  set isloggedin(bool value) {
    _sharedPrefs.setBool(keyUserLoggedIn, value);
  }

}

final sharedPrefs = SharedPrefs();
