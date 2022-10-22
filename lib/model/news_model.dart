import 'dart:convert';
import 'package:sale_soft/common/date_time_helper.dart';

class NewsModel {
  int? id;
  String? title;
  String? content;
  String? summary;
  String? image;
  DateTime? date;
  String? source;
  String? dataJson;
  String? LinkWebsite;

  NewsModel(
      {this.id,
      this.title,
      this.content,
      this.summary,
      this.image,
      this.date,
      this.source,
      this.dataJson,
      this.LinkWebsite});

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Title': title,
      'Content': content,
      'Summary': summary,
      'Image': image,
      'Date': DateTimeHelper.dateToStringFormat(date: date),
      'Source': source,
      'DataJson': dataJson,
      'LinkWebsite': LinkWebsite
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
        id: map['ID'],
        title: map['Title'],
        content: map['Content'],
        summary: map['Summary'],
        image: map['Image'],
        date: DateTimeHelper.stringToDate(dateStr: map['Date']),
        source: map['Source'],
        dataJson: map['DataJson'],
        LinkWebsite: map['LinkWebsite']);
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source));

  static List<NewsModel> listFromJson(list) =>
      List<NewsModel>.from(list.map((x) => NewsModel.fromMap(x)));
}

extension NewsModelExt on NewsModel {
  String getDateDisplay() {
    return DateTimeHelper.dateToStringFormat(date: date) ?? '';
  }
}
