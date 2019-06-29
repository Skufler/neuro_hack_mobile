class Contact {
  int uid;
  String name;
  String surname;
  String avatar;

  Contact({this.uid, this.name, this.surname, this.avatar});

  Contact.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        name = map['name'],
        surname = map['surname'],
        avatar = map['avatar'];
}
