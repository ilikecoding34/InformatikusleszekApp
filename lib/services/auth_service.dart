import 'package:blog/config/http_config.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final shared = PreferencesService();
  final HttpConfig api = HttpConfig();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserModel? _user;

  bool _isloggedin = false;
  bool verificationsent = false;
  bool verificationdone = false;
  bool authfailed = false;
  bool done = false;
  bool bregistration = false;

  bool get authenticated => _isloggedin;
  UserModel? get user => _user;

  void changeToLogin() {
    bregistration = false;
    notifyListeners();
  }

  void changeToReg() {
    bregistration = true;
    notifyListeners();
  }

  Future login({Map? creds}) async {
    _isloggedin = false;
    try {
      String? token;
      String? userid;
      api.response = await api.dio.post('/login', data: creds).then((value) {
        token = value.data['token'].toString();
        userid = value.data['user_id'].toString();
      });

      shared.storeToken(token: token, userid: userid);

      if (token != null) {
        _isloggedin = true;
      }
      notifyListeners();
    } catch (e) {
      //   print(e);
      notifyListeners();
    }
  }

  Future registration({Map? creds}) async {
    _isloggedin = false;
    String? token;
    String? userid;
    try {
      api.response = await api.dio.post('/register', data: creds).then((value) {
        userid = value.data['user_id'].toString();
        token = value.data['access_token'].toString();
      });
      SharedPreferences prefs = await _prefs;

      prefs.setString('token', token!);
      prefs.setString('user_id', userid!);

      verificationsent = true;
      bregistration = false;
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future verification(String code) async {
    _isloggedin = false;
    SharedPreferences prefs = await _prefs;
    String? userid = prefs.getString('user_id');
    try {
      String url = '/verify/$userid/$code';
      api.response = await api.dio.get(url);
      if (api.response!.data != null) {
        verificationdone = true;
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }
}
