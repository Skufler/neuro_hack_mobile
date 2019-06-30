class EvalData {
  int uid;
  int evaluator;
  String date;
  int partnership;
  int joint;
  int responsibility;
  int kindness;
  int trust;
  int anger;
  int irritability;
  int compliance;
  int sociopathy;
  int isolation;

  EvalData(
      {this.uid,
      this.evaluator,
      this.date,
      this.partnership,
      this.joint,
      this.responsibility,
      this.kindness,
      this.trust,
      this.anger,
      this.irritability,
      this.compliance,
      this.sociopathy,
      this.isolation});

  EvalData.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    evaluator = json['evaluator'];
    date = json['date'];
    partnership = json['partnership'];
    joint = json['joint'];
    responsibility = json['responsibility'];
    kindness = json['kindness'];
    trust = json['trust'];
    anger = json['anger'];
    irritability = json['irritability'];
    compliance = json['compliance'];
    sociopathy = json['sociopathy'];
    isolation = json['isolation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['evaluator'] = this.evaluator;
    data['date'] = this.date;
    data['partnership'] = this.partnership;
    data['joint'] = this.joint;
    data['responsibility'] = this.responsibility;
    data['kindness'] = this.kindness;
    data['trust'] = this.trust;
    data['anger'] = this.anger;
    data['irritability'] = this.irritability;
    data['compliance'] = this.compliance;
    data['sociopathy'] = this.sociopathy;
    data['isolation'] = this.isolation;
    return data;
  }
}
