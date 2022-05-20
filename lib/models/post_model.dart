import 'package:blog/models/comment_model.dart';
import 'package:blog/models/tag_model.dart';
import 'package:blog/models/user_model.dart';

class PostModel {
  int id;
  String title;
  String? link;
  String body;
  UserModel? user;
  List<TagModel> tags;
  List<CommentModel> comments;

  PostModel(this.id, this.title, this.link, this.body, this.user, this.tags,
      this.comments);

  PostModel.fromJson(json)
      : id = json['id'],
        title = json['title'],
        link = json['link'],
        body = json['body'],
        user = UserModel.fromJson(json['user']),
        tags = json["tags"] == null
            ? <TagModel>[]
            : List<TagModel>.from(json["tags"].map((x) => TagModel.fromJson(x)))
                .toList(),
        comments = json["comments"] == null
            ? <CommentModel>[]
            : List<CommentModel>.from(
                json["comments"].map((x) => CommentModel.fromJson(x))).toList();
}
