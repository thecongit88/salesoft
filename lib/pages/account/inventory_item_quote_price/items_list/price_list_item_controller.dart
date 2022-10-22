import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/model/inventory_item_category_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/params/get_inventory_items_param.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:collection/collection.dart';
import 'package:sale_soft/model/price_list_option.dart';
import 'package:sale_soft/model/price_quote_cart_model.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/send_price_quote/create_price_list_controller.dart';

class PriceListItemsController extends GetxController
    with StateMixin<List<PriceListOption>> {

  PriceListOption? chinhSachGia;
  List<PriceListOption> dsChinhSachGia = [];

  //Tổng cuối
  final totalQty = 0.obs;
  final totalAmount = 0.0.obs;

  String giaSi = 'GiaSi';
  String endUser = 'EndUser';

  PriceListObjectArgument? argument;

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments;
    dsChinhSachGia = [
      PriceListOption(Code: '$giaSi', Id: null, Name: 'Giá sỉ'),
      PriceListOption(Code: '$endUser', Id: null, Name: 'Giá lẻ (End User)'),
    ];
    change(null, status: RxStatus.success());
  }

  setChinhSachGia(PriceListOption val) {
    chinhSachGia = val;
    update();
  }

  calcTotalInItemList(List<InventroyItemModel> listItemsInCart) {
    totalAmount.value = 0; totalQty.value = 0;
    listItemsInCart.forEach((InventroyItemModel it) {
      double promo = it.promotion <= 100 ? (it.promotion/100) * it.donGiaBaoGia : it.promotion;
      totalQty.value += it.soluongBaoGia;
      totalAmount.value += it.soluongBaoGia * it.donGiaBaoGia - promo;
    });
  }

  removeItemInItemList(InventroyItemModel it, List<InventroyItemModel> listItemsInCart) {
    listItemsInCart.removeWhere((InventroyItemModel el) => el.code == it.code);
    update();
  }
}
