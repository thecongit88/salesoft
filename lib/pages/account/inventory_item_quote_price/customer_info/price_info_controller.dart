import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/inventory_item_category_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/params/get_inventory_items_param.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:collection/collection.dart';
import 'package:sale_soft/model/price_list_option.dart';
import 'package:sale_soft/model/price_quote_cart_model.dart';
import 'package:sale_soft/model/represent_model.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/choose_items/inventory_item_quote_price_controller.dart';

class PriceInfoController extends GetxController
    with StateMixin<List<PriceListOption>> {


  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  /// Repository
  final IReportRepository _repository = Get.find();

  /// dành cho báo giá
  PriceListOption? xungDanh;
  List<PriceListOption> dsXungDanh = [];

  String? tuXung;
  List<String> dsTuXung = ['Em', 'Tôi', 'Mình', 'Anh', 'Chị'];

  String tienTe = 'VNĐ';
  List<String> dsTienTe = ['VNĐ', 'USD'];

  PriceListOption? daiLy;
  List<PriceListOption> dsDaiLy = [];

  PriceListOption? phuongThucVanChuyen;
  List<PriceListOption> dsPhuongThucVanChuyen = [];

  PriceListOption? thoiGianCapHang;
  List<PriceListOption> dsThoiGianCapHang = [];

  PriceListOption? dieuKienThanhToan;
  List<PriceListOption> dsDieuKienThanhToan = [];

  DateTime fromDate = DateTime.now(), toDate = DateTime.now();
  late String tuNgay = "${DateFormat('dd/MM/yyyy').format(DateTime.now())}";
  late String denNgay = "${DateFormat('dd/MM/yyyy').format(DateTime.now())}";

  final customerCodeEditController = TextEditingController();
  final customerNameEditController = TextEditingController();
  final customerEmailEditController = TextEditingController();
  final nguoiDaiDienEditController = TextEditingController();
  final soDienThoaiEditController = TextEditingController();
  final includeVat = false.obs;
  final isSelectedCustomer = false.obs;

  CustomerModel? customerSelected;
  final controllerCart = Get.find<InventoryItemQuotePriceController>();

  @override
  void onInit() {
    initFieldsData();
    getListXungDanh();
    getListDaiLy();
    getListPhuongThucVanChuyen();
    getListThoiGianGiaoHang();
    getListDieuKienThanhToan();
    super.onInit();
  }

  initFieldsData() {
    customerCodeEditController.text = controllerCart.customerCode;
    customerNameEditController.text = controllerCart.customerName;
    customerEmailEditController.text = controllerCart.customerEmail;
    nguoiDaiDienEditController.text = controllerCart.nguoiDaiDien;
    soDienThoaiEditController.text = controllerCart.customerPhone;
    tuXung = controllerCart.tuXung == null
        ? null
        : dsTuXung.firstWhere((item) => controllerCart.tuXung != null && item == controllerCart.tuXung);
    tienTe = controllerCart.tienTe == null
        ? "VNĐ"
        : dsTienTe.firstWhere((item) => controllerCart.tienTe != null && item == controllerCart.tienTe);

    fromDate = controllerCart.fromDate == null ? DateTime.now() : controllerCart.fromDate!;
    toDate = controllerCart.toDate == null ? DateTime.now() : controllerCart.toDate!;
    includeVat.value = controllerCart.includeVat.value;
  }
  ///API eco3d báo giá
  ///
  Future<void> getListXungDanh({bool isLoadMore = false}) async {
    final result = await _repository.getListXungDanh();
    dsXungDanh = [];
    if (result?.isNotEmpty == true) {
      dsXungDanh.addAll(result ?? []);
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }
    xungDanh = controllerCart.xungDanh == null
        ? null
        : dsXungDanh.firstWhere((item) => controllerCart.xungDanh != null && item.Code == controllerCart.xungDanh!.Code);
    change(null, status: RxStatus.success());
  }

  Future<void> getListDaiLy({bool isLoadMore = false}) async {
    final result = await _repository.getListDaiLy();

    if (result?.isNotEmpty == true) {
      dsDaiLy.addAll(result ?? []);
    }
    daiLy = controllerCart.daiLy == null
        ? null
        : dsDaiLy.firstWhere((item) => controllerCart.daiLy != null && item.Code == controllerCart.daiLy!.Code);
    change(null, status: RxStatus.success());
  }

  Future<void> getListPhuongThucVanChuyen({bool isLoadMore = false}) async {
    final result = await _repository.getListPhuongThucVanChuyen();

    if (result?.isNotEmpty == true) {
      dsPhuongThucVanChuyen.addAll(result ?? []);
    }

    phuongThucVanChuyen = controllerCart.phuongThucVanChuyen == null
        ? null
        : dsPhuongThucVanChuyen.firstWhere((item) => controllerCart.phuongThucVanChuyen != null && item.Code == controllerCart.phuongThucVanChuyen!.Code);
    change(null, status: RxStatus.success());
  }

  Future<void> getListThoiGianGiaoHang({bool isLoadMore = false}) async {
    final result = await _repository.getListThoiGianGiaoHang();

    if (result?.isNotEmpty == true) {
      dsThoiGianCapHang.addAll(result ?? []);
    }

    thoiGianCapHang = controllerCart.thoiGianCapHang == null
        ? null
        : dsThoiGianCapHang.firstWhere((item) => controllerCart.thoiGianCapHang != null && item.Code == controllerCart.thoiGianCapHang!.Code);
    change(null, status: RxStatus.success());
  }

  Future<void> getListDieuKienThanhToan({bool isLoadMore = false}) async {
    final result = await _repository.getListDieuKienThanhToan();

    if (result?.isNotEmpty == true) {
      dsDieuKienThanhToan.addAll(result ?? []);
    }

    dieuKienThanhToan = controllerCart.dieuKienThanhToan == null
        ? null
        : dsDieuKienThanhToan.firstWhere((item) => controllerCart.dieuKienThanhToan != null && item.Code == controllerCart.dieuKienThanhToan!.Code);
    change(null, status: RxStatus.success());
  }

  setCustomer(CustomerModel customer) {
    customerSelected = customer;
    customerCodeEditController.text = customerSelected?.code ?? "";
    customerNameEditController.text = customerSelected?.name ?? "";
    controllerCart.customerCode = customerCodeEditController.text;
    controllerCart.customerName = customerNameEditController.text;
    isSelectedCustomer.value = true;
    change(null, status: RxStatus.success());
  }
}
