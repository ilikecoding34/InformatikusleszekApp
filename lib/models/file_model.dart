class FileModel {
  int? id;
  int? userid;
  int? postid;
  String? name;
  String? filepath;

  FileModel(this.id, this.userid, this.postid, this.name, this.filepath);

  FileModel.fromJson(json)
      : id = json['id'],
        userid = json["userid"],
        postid = json["postid"],
        name = json["name"],
        filepath = json["file_path"];
}
