import 'package:blog/models/comment_model.dart';

class PostModel {
  String title;
  String body;
  List<dynamic>? comments;

  PostModel(this.body, this.title, this.comments);

  PostModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'],
        comments = json['comments'];
}
