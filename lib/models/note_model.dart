class NoteModel {
  late int uId;
  late String text;
  String? title;
  String? dateTime;
  late String color;

  NoteModel({
    required this.uId,
    required this.text,
    this.title,
    this.dateTime,
    required this.color,
  });

// json is type from Map<String,dynamic>
  NoteModel.fromJson(dynamic json) {
    uId = json['uId'];
    text = json['text'];
    title = json['title'];
    dateTime = json['dateTime'];
    color = json['color'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'text': text,
      'title': title,
      'dateTime': dateTime,
      'color': color,
    };
  }
}
