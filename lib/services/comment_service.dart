import 'package:blog/config/http_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentService extends ChangeNotifier {
  bool collapse = false;
  List<dynamic> postlist = [];
  PostModel? singlepost;
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
        notifyListeners();
        return api.response!.data['id'];
      } catch (e) {
        print(e);
      }
    }
  }

  Future deleteComment({required Map datas}) async {
    await readToken();
    if (token == null) {
      return;
    } else {
      try {
        api.response = await api.dio.post(
          '/deletecomment',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: datas,
        );
        notifyListeners();
        return api.response!.data['id'];
      } catch (e) {
        print(e);
      }
    }
  }
}
