// @dart=2.7

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();
  static final backgroundKey = 'ejercicios_background';
  static final tokenKey = 'ejercicios_token';
  static final idAdminUser = 1;

  SharedPreferences _preferences;

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();

  initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  set ejercicosBackground(String background) {
    _preferences.setString(backgroundKey, background);
  }

  get ejercicosBackground {
    return _preferences.getString(backgroundKey) ??
        'assets/image/pizarraEntrenos.jpg';
  }

  set token(String token) {
    _preferences.setString(tokenKey, token);
  }

  String get token {
    return _preferences.getString(tokenKey);
  }
  String get idAdmin {
    return _preferences.getString(tokenKey);
  }
}
