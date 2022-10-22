import 'dart:convert';

class GetListCustomerParam {
  String? keyword;
  int page;
  ///loại khách hàng (khách hàng hoặc nhà cung cấp), dành cho filter danh sách khách hàng
  bool isCustomer;
  bool isSupplier;
  ///dành cho các loại khách hàng ở phía trang chủ: ví dụ phát sinh, phát sinh /3 tháng, phát sinh sau 3 tháng
  String? type;
  ///dành cho khách hàng công nợ trong khoảng thời gian từ ngày đến ngày
  String? fromDate;
  String? toDate;

  GetListCustomerParam({
    this.keyword,
    this.page = 1,
    this.isCustomer = true,
    this.isSupplier = true,
    this.type,
    this.fromDate,
    this.toDate
  });

  Map<String, dynamic> toMap() {
    return {
      'keyword': keyword,
      'page': page,
      'isCustomer': isCustomer,
      'isSupplier': isSupplier,
      'type': type,
      'fromDate': fromDate,
      'toDate': toDate,
    };
  }

  factory GetListCustomerParam.fromMap(Map<String, dynamic> map) {
    return GetListCustomerParam(
      keyword: map['keyword'],
      page: map['page'],
      isCustomer: map['isCustomer'],
      isSupplier: map['isSupplier'],
      fromDate: map['fromDate'],
      toDate: map['toDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetListCustomerParam.fromJson(String source) =>
      GetListCustomerParam.fromMap(json.decode(source));

  String get isCustomerStr => isCustomer == true ? "true" : "false";

  String get isSupplierStr => isSupplier == true ? "true" : "false";
}
