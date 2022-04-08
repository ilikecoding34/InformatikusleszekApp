class CommentModel {
  int? id;
  int? postId;
  int? userId;
  String? body;

  CommentModel({
    this.id,
    this.postId,
    this.userId,
    this.body,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"] == null ? 0 : json["id"],
        postId: json["post_id"] == null ? 0 : json["post_id"],
        userId: json["user_id"] == null ? 0 : json["user_id"],
        body: json["body"] == null ? '' : json["body"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? 0 : id,
        "post_id": postId == null ? 0 : postId,
        "user_id": userId == null ? 0 : userId,
        "body": body == null ? '' : body,
      };
}
