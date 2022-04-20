class UserModel {
  String name;
  String email;

  UserModel(this.email, this.name);

  UserModel.fromJson(json)
      : name = json['name'],
        email = json['email'];
}
