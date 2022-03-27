class PostModel {
  String title;
  String body;

  PostModel(this.body, this.title);

  PostModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'];
}
