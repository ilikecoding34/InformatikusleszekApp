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

  factory CommentModel.fromJson(json) => CommentModel(
        id: json["id"] ?? 0,
        postId: json["post_id"] ?? 0,
        userId: json["user_id"] ?? 0,
        body: json["body"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "post_id": postId ?? 0,
        "user_id": userId ?? 0,
        "body": body ?? '',
      };
}
