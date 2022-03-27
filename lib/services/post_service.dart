import 'package:blog/config/http_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Postservice extends ChangeNotifier {
  List<dynamic> postlist = [];
  var singlepost;
  final HttpConfig api = HttpConfig();

  void getallPost({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        api.response = await api.dio.get('/posts',
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        var _adat = api.response!.data;
        postlist = _adat.map((e) => PostModel.fromJson(e)).toList();
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void getPost({String? token, int? id}) async {
    if (token == null) {
      return;
    } else {
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
  }
}
