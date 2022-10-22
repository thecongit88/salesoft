import 'dart:convert';

class VideoModel {
  int? ID = null;
  int? STT = null;
  String? Name = null;
  String? Image = null;
  String? Url = null;
  String? Date = null;

  VideoModel({this.ID, this.STT, this.Name, this.Image, this.Url, this.Date});

  Map<String, dynamic> toMap() {
    return {
      "STT": STT,
      "ID": ID,
      "Name": Name,
      "Image": Image,
      "Url": Url,
      "Date": Date
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      STT: map["STT"],
      ID: map["ID"],
      Name: map["Name"],
      Image: map["Image"],
      Url: map["Url"],
      Date: map["Date"],
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory VideoModel.fromJson(String source) {
    return VideoModel.fromMap(json.decode(source));
  }

  static List<VideoModel> listFromJson(list) {
    return List<VideoModel>.from(list.map((x) => VideoModel.fromMap(x)));
  }
}
