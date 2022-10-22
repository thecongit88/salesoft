import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/base_model.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/inventory_item_detail_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/inventory_product_model.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/create_order_param.dart';
import 'package:sale_soft/model/params/kiem_kho_param.dart';
import 'package:sale_soft/model/plan.dart';
import 'package:sale_soft/model/product_info_model.dart';
import 'package:sale_soft/model/topsale_model.dart';
import 'package:sale_soft/model/warehouse.dart';
import 'package:sale_soft/common/utils.dart';

class KiemKhoController extends GetxController with StateMixin<String?> {
  bool documentExpanded = true;
  bool inventoryItemExpanded = false;
  bool saveOrderExpanded = false;
  bool topReceiptExpanded = false;
  List<WareHouseModel> listAllWarehouse = [];

  String orderCode = "";
  List<InventroyItemModel> listItem = [];
  DateTime deadlineDate = DateTime.now();
  WareHouseModel? warehouseSelected = null;
  PlanModel? planSelected = null;

  List<PlanModel> listAllPlansByKho = [];
  List<InventoryProductModel> listAllProductsByPlan = [];
  InventoryProductModel inventroyItemScanned = new InventoryProductModel();

  var isLoadingPlan = false.obs;
  var isLoadingProduct = false.obs;

  var isSelectedDaKiem = true.obs;
  var isSelectedChuaKiem = true.obs;
  var isKiemKhoTheoKeHoach = false.obs;

  /// Repository
  final IReportRepository _repository = Get.find();

  final textEditController = TextEditingController();

  int totalAllProducts = 0, totalDaKiem = 0, totalChuaKiem = 0;

  setSelectedWarehouse(WareHouseModel warehouse) async {
    for (WareHouseModel w in listAllWarehouse) {
      w.isSelected = false;
    }
    warehouse.isSelected = true;
    warehouseSelected = warehouse;
    //await getListProductsByPlan(warehouse.Ma!, "all");
    change(null, status: RxStatus.success());
  }

  setSelectedPlan(PlanModel planModel) {
    for (PlanModel w in listAllPlansByKho) {
      w.isSelected = false;
    }
    planModel.isSelected = true;
    planSelected = planModel;
    change(null, status: RxStatus.success());
  }

  setDeadlineDate(DateTime date) {
    deadlineDate = date;
    change(null, status: RxStatus.success());
  }

  setDocumentActive() {
    documentExpanded = true;
    inventoryItemExpanded = false;
    saveOrderExpanded = false;
    change(null, status: RxStatus.success());
  }

  setInventoryItemActive() {
    documentExpanded = false;
    inventoryItemExpanded = true;
    saveOrderExpanded = false;
    change(null, status: RxStatus.success());
  }

  setSaveOrderActive() {
    documentExpanded = false;
    inventoryItemExpanded = false;
    saveOrderExpanded = true;
    change(null, status: RxStatus.success());
  }

  @override
  void onInit() {
    super.onInit();
    getListWarehouse();
    change(null, status: RxStatus.success());
  }

  void getListWarehouse() async {
    final result = await _repository.getListWarehouse();

    if (result?.isNotEmpty == true) {
      listAllWarehouse..addAll(result ?? []);
    }

    ///xử lý trong trường hợp chỉ có 1 kho
    if(listAllWarehouse != null && listAllWarehouse.length == 1) {
      setSelectedWarehouse(listAllWarehouse.first);
      ///getListProductsByPlan(listAllWarehouse.first.Ma!, listAllWarehouse.first.Ma!);
      ///await getListProductsByPlan(listAllWarehouse.first.Ma!, "all"); //tất cả kế hoạch
      ///getListPlansByKho(listAllWarehouse.first.Ma!);
    }
    change(null, status: RxStatus.success());
  }

  List<WareHouseModel> searchWarehouseByKey(String keyword) {
    return listAllWarehouse.where((element) {
      return element.Ten?.prepareForSearch()
              .contains(keyword.prepareForSearch()) ==
          true;
    }).toList();
  }

  void updateUi() {
    change(null, status: RxStatus.success());
  }

  getListPlansByKho(String maKho) async {
    //change(null, status: RxStatus.loading());
    isLoadingPlan.value = true;
    listAllPlansByKho = [];
    listAllProductsByPlan = [];
    planSelected = null;
    if(maKho != "") {
      final result = await _repository.getListPlansByKho(maKho);
      if (result?.isNotEmpty == true) {
        listAllPlansByKho.addAll(result ?? []);
      }
    }
    ///xử lý trong trường hợp chỉ có 1 kế hoạch
    if(listAllPlansByKho != null && listAllPlansByKho.length == 1) {
      setSelectedPlan(listAllPlansByKho.first);
      getListProductsByPlan(listAllWarehouse.first.Ma!, listAllPlansByKho.first.Ma!);
    }
    isLoadingPlan.value = false;
    change(null, status: RxStatus.success());
  }

  List<PlanModel> searchPlansByKey(String keyword) {
    return listAllPlansByKho.where((element) {
      return element.Ten?.prepareForSearch().contains(keyword.prepareForSearch()) == true ||
          element.Ma?.prepareForSearch().contains(keyword.prepareForSearch()) == true
      ;
    }).toList();
  }

  getListProductsByPlan(String inventoryCode, String planCode) async {
    //change(null, status: RxStatus.loading());
    isLoadingProduct.value = true;
    listAllProductsByPlan = [];
    if(inventoryCode != "" && planCode != "") {
      final result = await _repository.getListProductsByPlan(inventoryCode, planCode);
      if (result?.isNotEmpty == true) {
        listAllProductsByPlan.addAll(result ?? []);
        totalAllProducts = listAllProductsByPlan.length;
      }
    }
    isLoadingProduct.value = false;
    change(null, status: RxStatus.success());
  }

  sortBySoLuongKiemKho() {
    listAllProductsByPlan.sort((a, b) => a.quantity.compareTo(b.quantity));
  }

  InventoryProductModel getItemScanned(String code) {
    listAllProductsByPlan.forEach((InventoryProductModel element) {
      if(element.ma.toString().toUpperCase().trim() == code.toString().toUpperCase().trim()) {
        inventroyItemScanned = element;
      }
    });
    return this.inventroyItemScanned;
  }

  setSoLuongTonKhoPlan(double soluong) {
    inventroyItemScanned.quantity = soluong;
    //this.listAllProductsByPlan.removeWhere((InventoryProductModel it) => it.ma.toString().toUpperCase().trim() == inventroyItemScanned.ma.toString().toUpperCase().trim());
    //this.listAllProductsByPlan.insert(0, inventroyItemScanned);
    sortBySoLuongKiemKho();
    update();
  }

  removeKiemTon(String productCode) {
    this.listAllProductsByPlan.removeWhere((InventoryProductModel it) => it.ma.toString().toUpperCase().trim() == productCode.toString().toUpperCase().trim());
    update();
  }

  hasChangedList() {
    var tmpList = this.listAllProductsByPlan.where((InventoryProductModel it) => it.isSelected == true).toList();
    return tmpList != null && tmpList.length > 0 ? true : false;
  }

  setSoLuongTonKhoNoPlan(double soluong, ProductInfoModel item) {
    InventoryProductModel inventroyItem = new InventoryProductModel();
    inventroyItem.ma = item.code;
    inventroyItem.ten = item.name;
    inventroyItem.unit = item.unit;
    inventroyItem.quantity = soluong;
    inventroyItem.isSelected = true;
    this.listAllProductsByPlan.removeWhere((InventoryProductModel it) => it.ma.toString().toUpperCase().trim() == inventroyItem.ma.toString().toUpperCase().trim());
    this.listAllProductsByPlan.insert(0, inventroyItem);
    //sortBySoLuongKiemKho();
    update();
  }

  List<InventoryProductModel> searchProductsByKey() {
    String keyword = textEditController.value.text.trim();

    return keyword != ""
        ?
      listAllProductsByPlan.where((element) {
          return element.ma?.prepareForSearch().contains(keyword.prepareForSearch()) == true ||
              element.ten?.prepareForSearch().contains(keyword.prepareForSearch()) == true
          ;
      }).toList()
        :
    listAllProductsByPlan;


    return listAllProductsByPlan.where((element) {
      if(this.isSelectedDaKiem.value == true && this.isSelectedChuaKiem.value == true) {
        return element.ma?.prepareForSearch().contains(keyword.prepareForSearch()) == true ||
            element.ten?.prepareForSearch().contains(keyword.prepareForSearch()) == true
        ;
      } else {
        if(this.isSelectedDaKiem.value == true) {
          return (element.ma?.prepareForSearch().contains(keyword.prepareForSearch()) == true ||
              element.ten?.prepareForSearch().contains(keyword.prepareForSearch()) == true)
            && element.quantity > 0
          ;
        } else if(this.isSelectedChuaKiem.value == true) {
          return (element.ma?.prepareForSearch().contains(keyword.prepareForSearch()) == true ||
              element.ten?.prepareForSearch().contains(keyword.prepareForSearch()) == true)
              && element.quantity <= 0
          ;
        } else {
          return element.ma?.prepareForSearch().contains(keyword.prepareForSearch()) == true ||
              element.ten?.prepareForSearch().contains(keyword.prepareForSearch()) == true
          ;
        }
      }
    }).toList();
  }

  int getTotalAllProducts() {
    return this.totalAllProducts;
  }

  int getTotalDaKiem() {
    return listAllProductsByPlan.where((element) {
      return element.quantity > 0;
    }).toList().length;
  }

  int getTotalChuaKiem() {
    return listAllProductsByPlan.where((element) {
      return element.quantity <= 0;
    }).toList().length;
  }

  void setIsKiemKhoTheoKeHoach(bool value) {
    this.listAllProductsByPlan = [];
    this.isKiemKhoTheoKeHoach.value = value;
    update();
  }

  bool getIsKiemKhoTheoKeHoach() {
    return this.isKiemKhoTheoKeHoach.value;
  }

  createKiemKho() async {
    change(null, status: RxStatus.loading());
    KiemKhoParam kiemKhoParam = new KiemKhoParam();
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final String code = responseLogin?.code ?? "";
    final int id = responseLogin?.id ?? 0;
    final key = responseLogin?.key ?? "";

    kiemKhoParam.UserID = id;
    kiemKhoParam.Code = code;
    kiemKhoParam.Ngay = DateTimeHelper.dateToStringFormat(date: DateTime.now());
    kiemKhoParam.Key = key;
    kiemKhoParam.Kho = warehouseSelected?.Ma ?? "";
    kiemKhoParam.KeHoach = planSelected?.Ma ?? "";

    List<ItemKiemKho> listItemKiemKho = [];

    this.listAllProductsByPlan.forEach((InventoryProductModel it) {
      var itKiemKho = new ItemKiemKho();
      itKiemKho.DetailID = 0;
      itKiemKho.Code = it.ma;
      itKiemKho.Quantity = it.quantity;
      listItemKiemKho.add(itKiemKho);
    });
    kiemKhoParam.list = listItemKiemKho;
    final result = await _repository.createKiemKho(kiemKhoParam);
    //đánh dấu là đã kiểm
    if(result == "1" || result == 1) {
      this.listAllProductsByPlan.forEach((InventoryProductModel it) {
        it.checked = true; //ẩn nút reomove màu đỏ
        it.isSelected = false; //không còn check là đang có phần tử thay đổi trong list sp kiểm kho
      });
    }
    change(result, status: RxStatus.success());
    return result;
  }
}
