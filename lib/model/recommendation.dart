class Recommendation {
  // int uid;
  String text;
  DateTime dateOfPublication; // date of publication
  String picture; // base64 picture

  Recommendation(
      {
      /*this.uid, */ this.text,
      this.dateOfPublication,
      this.picture});

  Recommendation.fromMap(Map<String, dynamic> map)
      : // uid = map['uid'],
        text = map['text'],
        dateOfPublication = DateTime.parse(map['date']),
        picture = map['picture'];
}
