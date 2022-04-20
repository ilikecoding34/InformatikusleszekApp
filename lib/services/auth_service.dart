import 'package:blog/config/http_config.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final shared = PreferencesService();
  final HttpConfig api = HttpConfig();
  UserModel? _user;

  bool _isloggedin = false;
  bool authfailed = false;
  bool done = false;

  bool get authenticated => _isloggedin;
  UserModel? get user => _user;

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
      print(e);
      notifyListeners();
    }
  }
}
