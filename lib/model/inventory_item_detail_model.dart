import 'package:sale_soft/common/date_time_helper.dart';

class InventoryItemDetailModel {
  int? sTT;
  String? code;
  String? code1;
  String? name;
  String? sumary;
  String? origin;
  String? tradeMark;
  double? price; //đây là giá bán sản phẩm khi bấm vào 1 chi tiết sản phẩm, khác với giá lẻ trong màn hình hiển thị danh sách sản phẩm
  String? image;
  double? quantity;
  DateTime? date1;
  double? priceMin;
  String? dVT;
  String? techParameter;
  List<ListWebsite>? listWebsite;
  List<ListImage>? listImage;
  List<ListVideo>? listVideo;
  List<ListDocument>? listDocument;
  String? listContent;

  int soluongBaoGia = 0;
  double? giaBaoGia = 0;

  InventoryItemDetailModel(
      {this.sTT,
        this.code,
        this.code1,
        this.name,
        this.sumary,
        this.origin,
        this.tradeMark,
        this.price,
        this.image,
        this.quantity,
        this.date1,
        this.priceMin,
        this.dVT,
        this.techParameter,
        this.listWebsite,
        this.listVideo,
        this.listDocument,
        this.listImage,
        this.listContent,
        this.soluongBaoGia = 0
      });

  factory InventoryItemDetailModel.fromMap(Map<String, dynamic> map) {
    return InventoryItemDetailModel(
        sTT: map['STT'],
        code: map['Code'],
        code1: map['Code1'],
        name: map['Name'],
        sumary: map['Sumary'],
        origin: map['Origin'],
        tradeMark: map['TradeMark'],
        price: map['Price'],
        image: map['Image'],
        quantity: map['Quantity'],
        date1: DateTimeHelper.stringToDate(dateStr: map['Date1'] ?? ''),
        priceMin: map['PriceMin'],
        dVT: map['DVT'],
        techParameter: map['TechParameter'].replaceAll(r'\', ''),
        listWebsite: ListWebsite.listWebsiteFromJson(map['ListWebsite']),
        listDocument: ListDocument.listDocumentFromJson(map['ListDocument']),
        listVideo: ListVideo.listVideoFromJson(map['ListVideo']),
        listImage: ListImage.listImageFromJson(map['ListImage']),
        listContent: map['ListContent']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'STT': this.sTT,
      'Code': this.code,
      'Code1': this.code1,
      'Name': this.name,
      'Sumary': this.sumary,
      'Origin': this.origin,
      'TradeMark': this.tradeMark,
      'Price': this.price,
      'Image': this.image,
      'Quantity': this.quantity,
      'Date1': DateTimeHelper.dateToStringFormat(),
      'PriceMin': this.priceMin,
      'DVT': this.dVT,
      'TechParameter': this.techParameter
    };
  }
}

class ListWebsite {
  String? name;
  String? linkUrl;

  ListWebsite({this.name, this.linkUrl});

  factory ListWebsite.fromMap(Map<String, dynamic> map) {
    return ListWebsite(
      name: map['Name'],
      linkUrl: map['LinkUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': this.name,
      'LinkUrl': this.linkUrl
    };
  }

  static List<ListWebsite> listWebsiteFromJson(list) =>
      List<ListWebsite>.from(
          list.map((x) => ListWebsite.fromMap(x)));
}

class ListDocument {
  String? name;
  String? linkUrl;

  ListDocument({this.name, this.linkUrl});

  factory ListDocument.fromMap(Map<String, dynamic> map) {
    return ListDocument(
      name: map['Name'],
      linkUrl: map['LinkUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': this.name,
      'LinkUrl': this.linkUrl
    };
  }

  static List<ListDocument> listDocumentFromJson(list) =>
      List<ListDocument>.from(
          list.map((x) => ListDocument.fromMap(x)));
}

class ListImage {
  String? name;
  String? linkUrl;

  ListImage({this.name, this.linkUrl});

  factory ListImage.fromMap(Map<String, dynamic> map) {
    return ListImage(
      name: map['Name'],
      linkUrl: map['LinkUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': this.name,
      'LinkUrl': this.linkUrl
    };
  }

  static List<ListImage> listImageFromJson(list) =>
      List<ListImage>.from(
          list.map((x) => ListImage.fromMap(x)));
}

class ListVideo {
  String? name;
  String? linkUrl;

  ListVideo({this.name, this.linkUrl});

  factory ListVideo.fromMap(Map<String, dynamic> map) {
    return ListVideo(
      name: map['Name'],
      linkUrl: map['LinkUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': this.name,
      'LinkUrl': this.linkUrl
    };
  }

  static List<ListVideo> listVideoFromJson(list) =>
      List<ListVideo>.from(
          list.map((x) => ListVideo.fromMap(x)));
}
