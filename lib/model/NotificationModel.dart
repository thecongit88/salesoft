import 'dart:convert';

class NotificationModel {
  int? STT = null;
  int? ID = null;
  String? Title = null;
  String? Content = null;
  String? Date1 = null;
  int? Status = 0;

  NotificationModel(
      {this.STT, this.ID, this.Title, this.Content, this.Date1, this.Status});

  Map<String, dynamic> toMap() {
    return {
      "STT": STT,
      "ID": ID,
      "Title": Title,
      "Content": Content,
      "Date1": Date1,
      "Status": Status
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      STT: map["STT"],
      ID: map["ID"],
      Content: map["Content"],
      Title: map["Title"],
      Date1: map["Date1"],
      Status: map["Status"],
    );
  }

  factory NotificationModel.fromJson(String source) {
    return NotificationModel.fromMap(json.decode(source));
  }

  static List<NotificationModel> listFromJson(list) {
    return List<NotificationModel>.from(
        list.map((x) => NotificationModel.fromMap(x)));
  }
}
