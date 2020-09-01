class Clip {
  String clip, time, date;
  Clip({this.clip, this.time, this.date});
  Clip.fromMap(Map<String, dynamic> map) {
    this.clip = map['clip'];
    this.time = map['time'];
    this.date = map['date'];
  }
  static Map<String, dynamic> toMap(Clip clip) {
    return {"clip": clip.clip, "time": clip.time, "date": clip.date};
  }
}
