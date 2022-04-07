import 'package:blog/models/comment_model.dart';

class PostModel {
  int id;
  String title;
  String body;
  List<dynamic> comments;

  PostModel(this.id, this.body, this.title, this.comments);

  PostModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        body = json['body'],
        comments = json['comments'];
}
