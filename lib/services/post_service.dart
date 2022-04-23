import 'package:blog/config/http_config.dart';
import 'package:blog/models/comment_model.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/models/user_model.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostService extends ChangeNotifier {
  bool collapse = false;
  bool postedit = false;
  List<dynamic> postlist = [];
  PostModel? singlepost;
  final HttpConfig api = HttpConfig();
  final shared = PreferencesService();

  void changecollapse() {
    collapse = !collapse;
    notifyListeners();
  }

  void setToModify() {
    postedit = !postedit;
    notifyListeners();
  }

  Future getallPost() async {
    try {
      api.response = await api.dio.get(
        '/posts',
      );
      var _adat = api.response!.data;
      postlist = _adat.map((e) => PostModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      //  print(e);
    }
  }

  void getPost({int? id}) async {
    try {
      api.response = await api.dio.get(
        '/post/$id',
      );
      var _adat = api.response!.data;
      singlepost = PostModel.fromJson(_adat);
      notifyListeners();
    } catch (e) {
      // print(e);
    }
  }

  Future modifyPost({required Map datas}) async {
    String? token = await shared.readToken();
    if (token == null) {
      return;
    } else {
      try {
        api.response = await api.dio.post(
          '/modifypost',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: datas,
        );
        var _adat = api.response!.data;
        postedit = false;
        notifyListeners();
        return _adat['id'];
      } catch (e) {
        //  print(e);
      }
    }
  }

  Future storePost({required Map datas}) async {
    String? token = await shared.readToken();
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
        //   print(e);
      }
    }
  }
}
