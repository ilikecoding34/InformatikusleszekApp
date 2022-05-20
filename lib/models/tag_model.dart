class TagModel {
  int id;
  String name;

  TagModel({
    required this.id,
    required this.name,
  });

  TagModel.fromJson(json)
      : id = json['id'],
        name = json['name'];
}
