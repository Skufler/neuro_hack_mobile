class User {
  int uid;
  int age;
  String name;
  String surname;
  String email;
  String avatar; // base64 picture

  User({this.uid, this.name, this.surname, this.email, this.age, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    avatar = json['avatar'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['age'] = this.age;
    return data;
  }
}
