import 'package:blog/models/comment_model.dart';
import 'package:blog/models/file_model.dart';
import 'package:blog/models/tag_model.dart';
import 'package:blog/models/user_model.dart';

class PostModel {
  int id;
  String title;
  String? link;
  String body;
  UserModel? user;
  FileModel? file;
  List<TagModel> tags;
  List<CommentModel> comments;
  String created;

  PostModel(this.id, this.title, this.link, this.body, this.user, this.tags,
      this.comments, this.created);

  PostModel.fromJson(json)
      : id = json['id'],
        title = json['title'],
        link = json['link'],
        body = json['body'],
        user = UserModel.fromJson(json['user']),
        file = json["file"] == null ? null : FileModel.fromJson(json['file']),
        tags = json["tags"] == null
            ? <TagModel>[]
            : List<TagModel>.from(json["tags"].map((x) => TagModel.fromJson(x)))
                .toList(),
        comments = json["comments"] == null
            ? <CommentModel>[]
            : List<CommentModel>.from(
                json["comments"].map((x) => CommentModel.fromJson(x))).toList(),
        created = json["created_at"];
}
