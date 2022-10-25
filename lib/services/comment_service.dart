import 'package:blog/config/http_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommentService extends ChangeNotifier {
  bool collapse = false;
  List<dynamic> postlist = [];
  int? commentchangeid;
  PostModel? singlepost;
  bool commentedit = false;
  final HttpConfig api = HttpConfig();

  PreferencesService shareddatas = PreferencesService();

  void changecomment() {
    commentedit = !commentedit;
    notifyListeners();
  }

  Future storeComment({required Map datas}) async {
    String? token = await shareddatas.readToken();
    datas['userid'] = await shareddatas.readUserId();
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

  Future modifyComment({required Map datas}) async {
    String? token = await shareddatas.readToken();
    if (token == null) {
      return;
    } else {
      try {
        api.response = await api.dio.post(
          '/modifycomment',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: datas,
        );
        commentedit = false;
        notifyListeners();
        return datas['postid'];
      } catch (e) {
        print(e);
      }
    }
  }

  Future deleteComment({required Map datas}) async {
    String? token = await shareddatas.readToken();
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
