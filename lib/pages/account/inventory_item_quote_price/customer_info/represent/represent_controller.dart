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

class RepresentController extends GetxController
    with StateMixin<List<RepresentModel>> {

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  /// Repository
  final IReportRepository _repository = Get.find();

  //Người đại diện
  List<RepresentModel> listAllReprent = [], listAllReprentOrg = [], listAllReprentTmp = [];
  String? customerCode;

  @override
  void onInit() {
    super.onInit();
    //getNguoiDaiDien("");
  }

  ///api get all người đại diện
  getNguoiDaiDien(String keyWord) async {
    change(null, status: RxStatus.loading());
    refreshController.resetNoData();
    listAllReprent =
        await _repository.getNguoiDaiDien(customerCode ?? "", keyWord) ?? [];

    if (listAllReprent.isNotEmpty == true) {
      listAllReprentOrg = listAllReprent;
      refreshController.loadComplete();
    } else {
      listAllReprentOrg = [];
      refreshController.loadNoData();
    }

    change(listAllReprent,
        status: listAllReprent.isEmpty ? RxStatus.empty() : RxStatus.success());
  }
  ///tìm người đại diện
  searchRepresentByEmailOrPhone(String keyword) {
    change(null, status: RxStatus.loading());
    refreshController.resetNoData();

    if(keyword.isEmpty == true) {
      listAllReprent = listAllReprentOrg;
    } else {
      listAllReprentTmp =
          listAllReprent.where((element) {
            return element.Email?.prepareForSearch().contains(keyword.prepareForSearch()) == true
                || element.Phone?.prepareForSearch().contains(keyword.prepareForSearch()) == true;
          }).toList();
      listAllReprent = listAllReprentTmp;
    }

    if (listAllReprent.isNotEmpty == true) {
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }

    change(listAllReprent,
        status: listAllReprent.isEmpty ? RxStatus.empty() : RxStatus.success());
  }
}
