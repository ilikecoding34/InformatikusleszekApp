class CommentModel {
  String title;
  String body;

  CommentModel(this.body, this.title);

  CommentModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'];
}
