import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/get_list_customer_param.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/get_inventory_items_param.dart';
import 'package:sale_soft/model/params/kiem_kho_param.dart';
import 'package:sale_soft/model/params/revenue_param.dart';
import 'package:sale_soft/model/price_list_object.dart';

abstract class IReportProvider {
  Future<dynamic> fetchCastbook(RevenueParam param);

  Future<dynamic> fetchCashflow(RevenueParam param);

  Future<dynamic> revenue(RevenueParam param);

  Future<dynamic> fetchStaffRevenue();

  Future<dynamic> getStores();

  Future<dynamic> getListCustomer(GetListCustomerParam param);

  Future<dynamic> getListDebtCustomer(GetListCustomerParam param);

  Future<dynamic> getListOrders(GetListCustomerParam param);

  Future<dynamic> getCustomerInfo(String customerCode);

  Future<dynamic> getDetailInventoryItem({required String productCode});

  Future<dynamic> getCustomerInvoice(String customerCode);

  Future<dynamic> getTopSale(String customerCode, int type);

  Future<dynamic> getInventoryItems(GetInventoryItemsParam param);

  Future<dynamic> getInventoryItemCategory(String keyword);

  Future<dynamic> getListPlansByKho(String maKho);

  Future<dynamic> getListProductsByPlan(String inventoryCode, String planCode);

  Future<dynamic> getListWarehouse();

  Future<dynamic> getOrderDetail(String code);

  Future<dynamic> createKiemKho(KiemKhoParam kiemKhoParam);

  Future<dynamic> getProductDetailInKho(String code);

  Future<dynamic> confirmOrder(String orderCode);

  ///API eco3d báo giá
  Future<dynamic> getListXungDanh();
  Future<dynamic> getListDaiLy();
  Future<dynamic> getListPhuongThucVanChuyen();
  Future<dynamic> getListThoiGianGiaoHang();
  Future<dynamic> getListDieuKienThanhToan();
  Future<dynamic> getMessageBaoGia(PriceListObject param);
  Future<dynamic> sendBaoGia(PriceListObject param);
  Future<dynamic> getNguoiDaiDien(String customerCode, String keyword);
}

class ReportProviderAPI implements IReportProvider {
  ///API eco3d báo giá
  late Dio dioEco3D;

  @override
  Future revenue(RevenueParam param) async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    var branchsQuery = param.branchs?.map((e) => e.id).join(',');
    branchsQuery = branchsQuery?.isNotEmpty == true ? branchsQuery : "all";
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';
    final urlEndPoint =
        "${UrlHelper.REPORT_REVENUE}/${param.getFromDateStr()}/${param.getToDateStr()}/$branchsQuery/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future fetchStaffRevenue() async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';
    final urlEndPoint =
        "${UrlHelper.REPORT_STAFF_REVENUE}/${responseLogin?.code ?? ''}/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getStores() async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final urlEndPoint =
        "${UrlHelper.REPORT_STORES}/all/${responseLogin?.key ?? ''}";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future fetchCastbook(RevenueParam param) async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    var branchsQuery = param.branchs?.map((e) => e.id).join(',');
    branchsQuery = branchsQuery?.isNotEmpty == true ? branchsQuery : "all";
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';
    final urlEndPoint =
        "${UrlHelper.REPORT_CASTBOOK}/${param.getFromDateStr()}/${param.getToDateStr()}/$branchsQuery/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future fetchCashflow(RevenueParam param) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    var branchsQuery = param.branchs?.map((e) => e.id).join(',');
    branchsQuery = branchsQuery?.isNotEmpty == true ? branchsQuery : "all";
    final key = responseLogin?.key ?? '';
    final urlEndPoint =
        "${UrlHelper.REPORT_CASTFLOW}/${param.getFromDateStr()}/${param.getToDateStr()}/$branchsQuery/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListCustomer(GetListCustomerParam param) async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final staff =
        responseLogin?.userType.toString().toUpperCase().trim() == AppConstant.loginAdmin.toUpperCase() ? "all" : responseLogin?.code ?? "";
    final keyword = param.keyword?.isEmpty == true ? "all" : param.keyword;
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';
    final type = param.type?.isEmpty == true ? "all" : param.type;

    final urlEndPoint =
        "${UrlHelper.REPORT_CUSTOMERS}/$keyword/$staff/${param.isCustomerStr}/${param.isSupplierStr}/$type/${param.page}/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getCustomerInfo(String customerCode) async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';

    final urlEndPoint =
        "${UrlHelper.REPORT_CUSTOMER_DETAIL}/$customerCode/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getDetailInventoryItem({required String productCode}) async {
    //sample data
    //return json.decode('[{ "STT": 1, "Code": "KA9101", "Name": "Khẩu trang chống bụi trắng H910Plus KN95 đeo tai (thùng 600 cái)", "Origin": "", "TradeMark": "Honeywell", "Price": 0.0000, "Price0": 3900000.0000, "Price1": 3530000.0000, "Price2": 4100000.0000, "Price3": 3790000.0000, "Price4": 174.8600, "Quantity": 105000.00, "Unit": "Thùng" }]');

    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';

    final urlEndPoint =
        "${UrlHelper.REPORT_INVENTORY_ITEM_DETAIL}/$productCode/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getCustomerInvoice(String customerCode) async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';

    final urlEndPoint =
        "${UrlHelper.REPORT_CUSTOMER_INVOICE}/$customerCode/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getTopSale(String customerCode, int type) async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';

    final urlEndPoint =
        "${UrlHelper.REPORT_CUSTOMER_TOP_SALE}/$customerCode/$type/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getInventoryItems(GetInventoryItemsParam param) async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';
    final urlEndPoint =
        "${UrlHelper.REPORT_INVENTORY_ITEM}/${param.keyword}/${param.category}/${param.page}/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getInventoryItemCategory(String keyword) async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final keywordParam = keyword.isNotEmpty == true ? keyword : "all";
    final urlEndPoint =
        "${UrlHelper.REPORT_INVENTORY_ITEM_CATEGORY}/$keywordParam/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListDebtCustomer(GetListCustomerParam param) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final staff =
    responseLogin?.userType.toString().toUpperCase().trim() == AppConstant.loginAdmin.toUpperCase() ? "all" : responseLogin?.code ?? "";
    final keyword = param.keyword?.isEmpty == true ? "all" : param.keyword;
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';

    final urlEndPoint =
        "${UrlHelper.LIST_DEBT_CUSTOMERS}/$keyword/$staff/${param.fromDate}/${param.toDate}/${param.page}/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  ///Lấy danh sách phiếu đặt hàng, type = 2
  ///Lấy danh sách hóa đơn bán hàng, type = 1
  ///Lấy danh sách hóa đơn nợ quá hạn, type = 3
  @override
  Future getListOrders(GetListCustomerParam param) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    //final staff = responseLogin?.userType.toString().toUpperCase().trim() == AppConstant.loginAdmin.toUpperCase() ? "all" : responseLogin?.code ?? "";
    final staff = "all";
    final keyword = param.keyword?.isEmpty == true ? "all" : param.keyword;
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';
    ///mặc định sẽ lấy danh sách hóa đơn bán hàng
    final type = param.type?.isEmpty == true ? "1" : param.type;

    final urlEndPoint =
        "${UrlHelper.REPORT_ORDER_CATEGORY}/$keyword/$staff/${param.fromDate}/${param.toDate}/$type/${param.page}/$key/$keyLog";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListPlansByKho(String maKho) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final urlEndPoint =
        "${UrlHelper.REPORT_LIST_PLAN_BY_KHO}/$maKho/${responseLogin?.key ?? ''}";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListProductsByPlan(String inventoryCode, String planCode) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();

    final staff =
    responseLogin?.userType.toString().toUpperCase().trim() == AppConstant.loginAdmin.toUpperCase() ? "all" : responseLogin?.code ?? "";
    final key = responseLogin?.key ?? '';
    final ngay = DateTimeHelper.dateToStringFormat4Filter(date: DateTime.now());
    final urlEndPoint =
        "${UrlHelper.REPORT_LIST_PRODUCT_BY_PLAN}/$inventoryCode/$planCode/$ngay/$staff/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListWarehouse() async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final id = responseLogin?.id ?? "";
    final urlEndPoint = "${UrlHelper.LIST_WAREHOUSE}/$id/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getOrderDetail(String code) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.ORDER_DETAIL}/$code/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future createKiemKho(KiemKhoParam kiemKhoParam) async {
    final urlEndPoint = "${UrlHelper.CREATE_KIEM_KHO}";
    return await HttpUtil().post(urlEndPoint, params: kiemKhoParam.toJson());
  }

  @override
  Future getProductDetailInKho(String code) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.PRODUCT_INFO_KHO}/$code/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future confirmOrder(String orderCode) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.CONFIRM_ORDER}/$orderCode/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListXungDanh() async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.LIST_XUNG_DANH}/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListDaiLy() async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.LIST_DAI_LY}/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListPhuongThucVanChuyen() async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.LIST_PHUONG_THUC_VAN_CHUYEN}/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListThoiGianGiaoHang() async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.LIST_THOI_GIAN_GIAO_HANG}/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getListDieuKienThanhToan() async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.LIST_DIEU_KIEN_THANH_TOAN}/$key";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getMessageBaoGia(PriceListObject param) async {
    ///chỗ này chú ý là base api hơi khác
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.GET_MESSAGE_BAO_GIA}";
    var model = jsonDecode("{\"XungDanh\": \"${param.XungDanh}\", \"TuXung\": \"${param.TuXung}\", \"NguoiDaiDien\": \"${param.NguoiDaiDien}\", \"Ten\": \"${param.Ten}\", \"Key\": \"$key\"}");
    return await HttpUtil().post(urlEndPoint, params: model);
  }

  ///dùng salesoft api
  @override
  Future sendBaoGia(PriceListObject param) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';

    final urlEndPoint = "${UrlHelper.SEND_BAO_GIA}";
    param.key = key;
    var model = jsonEncode(param.toJson());
    return await HttpUtil().post(urlEndPoint, params: model);
  }

  @override
  Future getNguoiDaiDien(String customerCode, String keyword) async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final keywordParam = keyword.isNotEmpty == true ? keyword : "all";
    final urlEndPoint = "${UrlHelper.BAO_GIA_CONTACT_LIST}/$customerCode/$keywordParam/$key";
    return await HttpUtil().get(urlEndPoint);
  }
}
