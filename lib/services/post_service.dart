import 'package:blog/config/http_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/models/tag_model.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostService extends ChangeNotifier {
  bool collapse = false;
  bool postedit = false;
  bool isLoading = false;
  List<int> tagselected = [];
  List<dynamic> postlist = [];
  List<dynamic> taglist = [];
  List<dynamic> filteredposts = [];
  PostModel? singlepost;

  final HttpConfig api = HttpConfig();
  final shared = PreferencesService();

  void changecollapse() {
    collapse = !collapse;
    notifyListeners();
  }

  void setToModify() {
    postedit = true;
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
      print(e);
    }
  }

  Future getallPostnewversion() async {
    try {
      api.response = await api.dio.get(
        '/postsnewversion',
      );
      var _adat = api.response!.data;
      postlist = _adat[0].map((e) => PostModel.fromJson(e)).toList();
      filteredposts = postlist;
      taglist = _adat[1].map((e) => TagModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      // print(e);
    }
  }

  tagsSelection(int id) {
    tagselected.contains(id) ? tagselected.remove(id) : tagselected.add(id);
    notifyListeners();
  }

  filterPosts(String name) {
    List<dynamic> filteringposts = [];
    if (name == 'all') {
      filteredposts = postlist;
    } else {
      for (int i = 0; i < postlist.length; i++) {
        if (postlist[i].tags != null) {
          if (postlist[i].tags.length > 0) {
            for (var tag in postlist[i].tags) {
              if (tag.name == name) {
                filteringposts.add(postlist[i]);
              }
            }
          }
        }
      }
      filteredposts = filteringposts;
    }
    notifyListeners();
  }

  Future getPost({int? id}) async {
    postedit = false;
    try {
      api.response = await api.dio.get(
        '/post/$id',
      );
      var _adat = api.response!.data;
      singlepost = PostModel.fromJson(_adat);
      isLoading = false;
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
