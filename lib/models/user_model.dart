class UserModel {
  String name;
  String email;

  UserModel(this.email, this.name);

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];
}
