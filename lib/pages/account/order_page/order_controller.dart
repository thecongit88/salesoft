import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/base_model.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/create_order_param.dart';
import 'package:sale_soft/model/topsale_model.dart';
import 'package:sale_soft/model/warehouse.dart';
import 'package:sale_soft/common/utils.dart';

class OrderController extends GetxController with StateMixin<String?> {
  var customerController = TextEditingController();

  bool documentExpanded = true;
  bool inventoryItemExpanded = false;
  bool saveOrderExpanded = false;
  bool topReceiptExpanded = false;
  List<WareHouseModel> listAllWarehouse = [];

  String orderCode = "";
  List<InventroyItemModel> listItem = [];
  DateTime deadlineDate = DateTime.now();
  WareHouseModel? warehouseSelected = null;
  CustomerModel? customerSelected = null;
  int tax = 10;
  double prepaid = 0.0;

  List<TopsaleModel> listTopSale = [];

  /// Repository
  final IReportRepository _repository = Get.find();

  setCustomer(CustomerModel customer) {
    customerSelected = customer;
    customerController.text = customerSelected?.name ?? "";

    if (listItem.isNotEmpty) {
      for (InventroyItemModel item in listItem) {
        setPriceByCustomerLevel(item);

        /// đưa giá theo cấp đại lý này vào trường Price, và dùng để tính toán
      }
    }

    change(null, status: RxStatus.success());
  }

  setSelectedWarehouse(WareHouseModel warehouse) {
    for (WareHouseModel w in listAllWarehouse) {
      w.isSelected = false;
    }
    warehouse.isSelected = true;
    warehouseSelected = warehouse;
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
    createOrderCode();
    getListWarehouse();
    getTopSale();
  }

  createOrder() async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final String code = responseLogin?.code ?? "";
    final int id = responseLogin?.id ?? 0;
    final key = responseLogin?.key ?? "";
    final idShop = responseLogin?.idShop ?? 0;

    List<Item> list = listItem
        .map((element) => Item(
            Id: element.code,
            Name: element.name,
            Quantity: element.quantity ?? 0.0,
            Price: element.Price ?? 0.0,
            Promo: element.promotion))
        .toList();

    CreateOrderParam param = CreateOrderParam(
        LoaiCT: "PhieuDatHang",
        ID: id,
        Code: code,
        Ngay: DateTimeHelper.dateToStringFormat(date: DateTime.now()),
        Kho: warehouseSelected?.Ma ?? "",
        Key: key,
        ChungTu: orderCode,
        KhachHang: customerSelected?.code ?? "",
        TenKhachHang: customerSelected?.name ?? "",
        DiaChi: "",
        TienHang: calculateTotalAmount(),
        MucThue: tax.toDouble(),
        TienThue: calculateTotalAmount() / 100 * tax,
        KhuyenMai: 0.0,
        PsCo: calculateTotalAmount() * (1 + tax / 100),
        PsNo: prepaid,
        ConLai: calculateTotalAmount() * (1 + tax / 100) - prepaid,
        IDCuaHang: idShop,
        GhiChu: "",
        HanThanhToan: DateTimeHelper.dateToStringFormat(date: deadlineDate),
        list: list);

    await HttpUtil()
        .post("${UrlHelper.CREATE_ORDER}", params: param.toJson())
        .then((value) {
      if (value != null) {
        if (value == "1") {
          showSuccessToast("Đặt hàng thành công");
          Get.back(result: value);
        }
      } else {
        return 0;
      }
    });
  }

  getTopSale() async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final id = responseLogin?.id ?? "";
    final code = responseLogin?.code ?? "";

    final urlEndPoint = "${UrlHelper.REPORT_CUSTOMER_TOP_SALE}/$code/2/$key";

    List<TopsaleModel> response =
        await HttpUtil().get(urlEndPoint).then((value) {
      if (value != null) {
        return Future<List<TopsaleModel>>.value(
            BaseModel.listFromJson<TopsaleModel>(
                value, (dataMap) => TopsaleModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    });

    if (response.isNotEmpty) {
      listTopSale.addAll(response);
    }
  }

  getListWarehouse() async {
    final result = await _repository.getListWarehouse();

    if (result?.isNotEmpty == true) {
      listAllWarehouse..addAll(result ?? []);
    }
  }

  createOrderCode() async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final id = responseLogin?.id ?? "";

    var response = await HttpUtil()
        .get("${UrlHelper.CREATE_ORDER_CODE}/$id/PDH/$key")
        .then((value) {
      return Future.value(value.toString());
    });
    orderCode = response;
    change(null, status: RxStatus.success());
  }

  List<WareHouseModel> searchWarehouseByKey(String keyword) {
    return listAllWarehouse.where((element) {
      return element.Ten?.prepareForSearch()
              .contains(keyword.prepareForSearch()) ==
          true;
    }).toList();
  }

  void setNewData(List<InventroyItemModel> newList) {
    listItem.clear();
    for (InventroyItemModel item in newList) {
      item.quantity = 1.0;
      setPriceByCustomerLevel(item);

      /// đưa giá theo cấp đại lý này vào trường Price, và dùng để tính toán
    }
    listItem.addAll(newList);
    change(null, status: RxStatus.success());
  }

  void updateUi() {
    change(null, status: RxStatus.success());
  }

  double getTotalQuantity() {
    double totalQuantity = 0.0;
    for (InventroyItemModel i in listItem) {
      totalQuantity += (i.quantity ?? 1.0);
    }
    return totalQuantity;
  }

  double calculateTotalPromotionAmount() {
    double total = 0.0;
    for (InventroyItemModel item in listItem) {
      double promotionAmount = 0.0;
      if (item.promotion > 100) {
        promotionAmount = item.promotion;
      } else {
        double total = (item.quantity ?? 0.0) * (item.Price ?? 0.0);
        promotionAmount = total * item.promotion / 100;
      }
      promotionAmount += promotionAmount;
    }
    return total;
  }

  double calculateTotalEachItem(InventroyItemModel item) {
    double total = (item.quantity ?? 0.0) * (item.Price ?? 0.0);
    double promotionAmount = 0.0;
    if (item.promotion > 100) {
      promotionAmount = item.promotion;
    } else {
      promotionAmount = total * item.promotion / 100;
    }

    return total - promotionAmount;
  }

  setPriceByCustomerLevel(InventroyItemModel item) {
    if (customerSelected != null) {
      switch (customerSelected!.level) {
        case 0:
          item.Price = item.Price0;
          break;
        case 1:
          item.Price = item.Price1;
          break;
        case 2:
          item.Price = item.Price2;
          break;
        case 3:
          item.Price = item.Price3;
          break;
        case 4:
          item.Price = item.Price4;
          break;
        default:
          item.Price = item.Price;
          break;
      }
    } else {
      item.Price = item.Price;
    }
  }

  double calculateTotalAmount() {
    double total = 0.0;
    for (InventroyItemModel item in listItem) {
      total += calculateTotalEachItem(item);
    }
    return total;
  }
}
