import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final storage = FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future readToken() async {
    String? token;
    SharedPreferences prefs = await _prefs;
    if (kIsWeb) {
      token = prefs.getString('token');
    } else {
      token = await storage.read(key: "token");
    }
    return token;
  }

  Future readUserId() async {
    String? userid;
    SharedPreferences prefs = await _prefs;
    if (kIsWeb) {
      userid = prefs.getString('user_id');
    } else {
      userid = await storage.read(key: "user_id");
    }
    return userid;
  }

  Future storeToken({String? token, String? userid}) async {
    SharedPreferences prefs = await _prefs;
    if (kIsWeb) {
      prefs.setString('token', token!);
      prefs.setString('user_id', userid!);
    } else {
      storage.write(key: 'token', value: token);
      storage.write(key: 'user_id', value: userid);
    }
  }

  storeThemeType(bool value) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool('darkMode', value);
  }

  readThemeType() async {
    SharedPreferences prefs = await _prefs;
    bool mode = prefs.getBool('darkMode') ?? true;
    return mode;
  }
}
