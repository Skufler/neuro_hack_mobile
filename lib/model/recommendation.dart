class Recommendation {
  String text;
  DateTime dateOfPublication; // date of publication
  String picture; // base64 picture

  Recommendation({this.text, this.dateOfPublication, this.picture});

  Recommendation.fromMap(Map<String, dynamic> map)
      : text = map['text'],
        dateOfPublication = DateTime.parse(map['date']),
        picture = map['picture'];
}
