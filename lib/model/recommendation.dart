class Recommendation {
  String text;
  String picture; // base64 picture
  DateTime dateOfPublication; // date of publication

  Recommendation({this.text, this.picture, this.dateOfPublication});

  Recommendation.fromMap(Map<String, dynamic> map)
      : text = map['text'],
        dateOfPublication = DateTime.parse(map['date']),
        picture = map['picture'];
}
