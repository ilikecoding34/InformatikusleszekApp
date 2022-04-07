class CommentModel {
  int? id;
  int? postId;
  String? body;

  CommentModel({
    this.id,
    this.postId,
    this.body,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"] == null ? 0 : json["id"],
        postId: json["post_id"] == null ? 0 : json["post_id"],
        body: json["body"] == null ? '' : json["body"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? 0 : id,
        "post_id": postId == null ? 0 : postId,
        "body": body == null ? '' : body,
      };
}
