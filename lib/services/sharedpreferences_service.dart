import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future readToken() async {
    String? token;
    SharedPreferences prefs = await _prefs;
    token = prefs.getString('token');
    return token;
  }

  Future readUserId() async {
    String? userid;
    SharedPreferences prefs = await _prefs;
    userid = prefs.getString('user_id');
    return userid;
  }

  Future storeToken({String? token}) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('token', token!);
  }

  Future storeUserId({String? userid}) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('user_id', userid!);
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
