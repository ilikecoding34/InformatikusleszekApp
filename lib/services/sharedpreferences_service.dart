import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  Future readToken() async {
    String? token;
    prefs = await _prefs;
    token = prefs.getString('token');
    return token;
  }

  Future readUserId() async {
    String? userid;
    prefs = await _prefs;
    userid = prefs.getString('user_id');
    return userid;
  }

  Future storeToken({String? token}) async {
    prefs = await _prefs;
    prefs.setString('token', token!);
  }

  Future storeUserId({String? userid}) async {
    prefs = await _prefs;
    prefs.setString('user_id', userid!);
  }

  Future logout() async {
    prefs = await _prefs;
    prefs.remove('user_id');
    prefs.remove('token');
    prefs.remove('darkMode');
  }

  storeThemeType(bool value) async {
    prefs = await _prefs;
    prefs.setBool('darkMode', value);
  }

  readThemeType() async {
    prefs = await _prefs;
    bool mode = prefs.getBool('darkMode') ?? true;
    return mode;
  }
}
