import 'package:blog/config/http_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserModel? _user;

  String? token;
  String? userid;

  final HttpConfig api = HttpConfig();

  bool _isloggedin = false;
  bool authfailed = false;
  bool done = false;

  bool get authenticated => _isloggedin;
  UserModel? get user => _user;

  Future login({Map? creds}) async {
    _isloggedin = false;
    try {
      String? token;
      api.response = await api.dio.post('/login', data: creds).then((value) {
        token = value.data['token'].toString();
        userid = value.data['user_id'].toString();
      });
      storeToken(token: token);

      if (token != null) {
        _isloggedin = true;
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  storeToken({String? token}) async {
    SharedPreferences prefs = await _prefs;
    if (kIsWeb) {
      prefs.setString('token', token!);
      prefs.setString('user_id', userid!);
    } else {
      storage.write(key: 'token', value: token);
      storage.write(key: 'user_id', value: userid);
    }
  }
}
