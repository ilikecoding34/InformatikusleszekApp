import 'dart:io';
import 'package:blog/config/http_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/models/tag_model.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PostService extends ChangeNotifier {
  bool _collapse = false;
  bool _postedit = false;
  bool _isLoading = false;
  bool _refreshing = false;
  bool _refresdone = false;
  double calculatedswipe = 0.0;
  double begin = 0.0;
  double end = 0.0;
  List<String> tagFilterList = [];
  List<int> _tagselected = [];
  List<dynamic> postlist = [];
  List<dynamic> _taglist = [];
  List<dynamic> _taglistoriginal = [];
  List<dynamic> filteredposts = [];
  PostModel? singlepost;

  late final String path;

  final HttpConfig api = HttpConfig();
  final shared = PreferencesService();

  get getRefreshing => _refreshing;
  set setRefreshing(bool val) => _refreshing = val;

  get getRefresdone => _refresdone;
  set setRefresdone(bool val) => _refresdone = val;

  get getIsloading => _isLoading;
  set setIsloading(bool val) => _isLoading = val;

  get getCollapse => _collapse;
  set setCollapse(bool val) => _collapse = val;

  get getPostEdit => _postedit;
  set setPostEdit(bool val) => _postedit = val;

  get getSelectedTags => _tagselected;
  get getAllTags => _taglist;

  void changecollapse() {
    _collapse = !_collapse;
    notifyListeners();
  }

  void refreshMovement() {
    if (end - begin > 100 && _refreshing) {
      _refreshing = false;
      getallPostnewversion();
      _refresdone = true;
    } else {
      calculatedswipe = end - begin;
    }
    if (_refreshing == false || calculatedswipe < 0) {
      calculatedswipe = 0.0;
    }
    notifyListeners();
  }

  void setToModify() {
    _postedit = true;
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
      _taglistoriginal = _adat[1].map((e) => TagModel.fromJson(e)).toList();
      _taglistoriginal.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      _taglist = _taglistoriginal;
      notifyListeners();
    } catch (e) {
      // print(e);
    }
  }

  tagsSelection(int id) {
    _tagselected.contains(id) ? _tagselected.remove(id) : _tagselected.add(id);
    notifyListeners();
  }

  filterPosts(String name) {
    if (name != 'all') {
      tagFilterList.contains(name)
          ? tagFilterList.remove(name)
          : tagFilterList.add(name);
    }
    List<dynamic> filteringposts = [];
    if (name == 'all' || tagFilterList.isEmpty) {
      tagFilterList.clear();
      filteredposts = postlist;
    } else {
      tagFilterList.sort((a, b) {
        return a.toLowerCase().compareTo(b.toLowerCase());
      });
      for (int i = 0; i < postlist.length; i++) {
        List posttagarray = [];
        if (postlist[i].tags != null) {
          if (postlist[i].tags.length > 0) {
            for (var tag in postlist[i].tags) {
              posttagarray.add(tag.name);
            }
            if (Set.of(posttagarray).containsAll(tagFilterList)) {
              filteringposts.add(postlist[i]);
            }
          }
        }
      }
      filteredposts = filteringposts;
    }
    notifyListeners();
  }

  Future getPost({required int id}) async {
    _postedit = false;
    try {
      api.response = await api.dio.get(
        '/post/$id',
      );
      var _adat = api.response!.data;
      singlepost = PostModel.fromJson(_adat);
      _tagselected.clear();
      singlepost!.tags.map((e) => {_tagselected.add(e.id)}).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // print(e);
    }
  }

  Future getfile({required int id}) async {
    String? token = await shared.readToken();
    var tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir!.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    try {
      api.response = await api.dio.get(
        '/filecontrol/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      String filename = api.response.toString().substring(8);

      await FileDownloader.downloadFile(
          url: 'https://informatikusleszek.hu/storage/app/public/$filename',
          name: "PANDA",
          onDownloadCompleted: (val) {
            OpenFile.open(val);
          });

      /*
      await OpenFile.open(
          'https://informatikusleszek.hu/storage/app/public/$filename');*/
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
        _postedit = false;
        notifyListeners();
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
