import 'package:blog/models/comment_model.dart';

class PostModel {
  int id;
  String title;
  String? link;
  String body;
  List<dynamic>? comments;

  PostModel(this.id, this.title, this.link, this.body, this.comments);

  PostModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        link = json['link'],
        body = json['body'],
        comments = json['comments'];
}
