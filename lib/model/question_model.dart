import 'dart:convert';

class QuestionModel {
  int? stt;
  int? id;
  String? name;
  String? reply;
  bool isExpanded;

  QuestionModel({
    this.stt,
    this.id,
    this.name,
    this.reply,
    this.isExpanded = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': stt,
      'ID': id,
      'Name': name,
      'Reply': reply,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      stt: map['STT'],
      id: map['ID'],
      name: map['Name'],
      reply: map['Reply'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(json.decode(source));

  static List<QuestionModel> listFromJson(list) =>
      List<QuestionModel>.from(list.map((x) => QuestionModel.fromMap(x)));
}