import 'dart:convert';

class ContactModel {
  int? STT = null;
  String? Name = null;
  String? Email = null;
  String? Phone = null;
  String? ImageUrl = null;
  String? Position = null;
  int? Type = null;

  ContactModel(
      {this.STT,
      this.Name,
      this.Email,
      this.Phone,
      this.ImageUrl,
      this.Type,
      this.Position});

  Map<String, dynamic> toMap() {
    return {
      "STT": STT,
      "Name": Name,
      "Email": Email,
      "Phone": Phone,
      "ImageUrl": ImageUrl,
      "Position": Position,
      "Type": Type
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
        STT: map["STT"],
        Email: map["Email"],
        Name: map["Name"],
        ImageUrl: map["ImageUrl"],
        Position: map["Position"],
        Phone: map["Phone"],
        Type: map["Type"]);
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory ContactModel.fromJson(String source) {
    return ContactModel.fromMap(json.decode(source));
  }

  static List<ContactModel> listFromJson(list) {
    return List<ContactModel>.from(list.map((x) => ContactModel.fromMap(x)));
  }
}
