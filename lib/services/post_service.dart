import 'package:blog/config/http_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Postservice extends ChangeNotifier {
  bool collapse = false;
  List<dynamic> postlist = [];
  var singlepost;
  final HttpConfig api = HttpConfig();

  final storage = FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? token;

  Future readToken() async {
    SharedPreferences prefs = await _prefs;
    if (kIsWeb) {
      token = prefs.getString('token');
    } else {
      token = await storage.read(key: "token");
    }
  }

  void coll() {
    collapse = !collapse;
    notifyListeners();
  }

  void getallPost() async {
    try {
      api.response = await api.dio.get(
        '/posts',
      );
      var _adat = api.response!.data;
      postlist = _adat.map((e) => PostModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void getPost({String? token, int? id}) async {
    try {
      api.response = await api.dio.get('/post/$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      var _adat = api.response!.data;
      singlepost = _adat[0];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future storePost({required Map datas}) async {
    await readToken();
    if (token == null) {
      return;
    } else {
      try {
        api.response = await api.dio.post(
          '/newpost',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: datas,
        );
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future storeComment({required Map datas}) async {
    await readToken();
    if (token == null) {
      return;
    } else {
      try {
        api.response = await api.dio.post(
          '/newcomment',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: datas,
        );
        var _adat = api.response!.data;
        singlepost = _adat;
        notifyListeners();
        return _adat['id'];
      } catch (e) {
        print(e);
      }
    }
  }
}
