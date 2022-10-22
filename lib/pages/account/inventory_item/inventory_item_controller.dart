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

class InventoryItemController extends GetxController
    with StateMixin<List<InventroyItemModel>> {
  // màn hình tạo phiếu đặt hàng có dùng màn hình này
  // biến này null tức là trong màn hình chọn hàng hóa

  List<InventroyItemModel>? argument = Get.arguments;
  List<InventroyItemModel>? listSelectedItem = [];

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  int page = 1;
  List<InventroyItemModel> inventoryItems = [];
  // Nhóm HH
  List<InventoryItemCategoryModel> inventoryItemCategories = [];
  // Category đang chọn
  var categorySelected = <InventoryItemCategoryModel>[].obs;

  final textEditController = TextEditingController();

  /// Repository
  final IReportRepository _repository = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchInventoryItemCategory();
    fetchInventoryItem();
    if (Get.arguments != null && Get.arguments is List) {
      listSelectedItem?.addAll(Get.arguments);
    }
  }

  void initSelectedList() {
    for (InventroyItemModel i in inventoryItems) {
      if (i.isSelected) {
        if (listSelectedItem!
                .firstWhereOrNull((element) => element.code == i.code) ==
            null) {
          listSelectedItem?.add(i);
        }
      } else {
        listSelectedItem?.removeWhere((element) => element.code == i.code);
      }
    }

    change(inventoryItems, status: RxStatus.success());
  }

  ///F
  /// Lấy dữ liệu ds Hàng hóa
  ///
  void fetchInventoryItem({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      page = 1;
      change(null, status: RxStatus.loading());
      this.inventoryItems = [];
      refreshController.resetNoData();
    } else {}

    final keyword = textEditController.value.text.trim();
    final categorySelectedQuery = categorySelected.value.isNotEmpty
        ? categorySelected.value.first.code ?? ''
        : 'all';
    final param = GetInventoryItemsParam(
        keyword: keyword.isEmpty ? 'all' : keyword,
        page: page,
        category: categorySelectedQuery);
    final result = await _repository.getListInventoryItems(param);

    if (result?.isNotEmpty == true) {
      if (listSelectedItem != null) {
        for (InventroyItemModel item in result!) {
          InventroyItemModel? find = listSelectedItem!
              .firstWhereOrNull((element) => item.code == element.code);
          item.isSelected = (find != null);
        }
      }

      inventoryItems.addAll(result ?? []);
      page++;
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }

    change(inventoryItems,
        status: inventoryItems.isEmpty ? RxStatus.empty() : RxStatus.success());
  }

  void fetchInventoryItemCategory() async {
    change(null, status: RxStatus.loading());
    inventoryItemCategories =
        await _repository.getInventoryItemCategory('') ?? [];
  }

  ///
  /// Lấy title theo ds cửa hàng đang chọn
  ///
  String getCategoryTitle() {
    final count = categorySelected.value.length;
    if (count > 0 && categorySelected.value.first.code != "all") {
      return categorySelected.first.name ?? '';
    } else {
      return "Toàn bộ";
    }
  }

  ///
  /// Tìm kiếm cửa hàng theo tên
  ///
  List<InventoryItemCategoryModel> searchCategoryByKey(String keyword) {
    return inventoryItemCategories.where((element) {
      return element.name
              ?.prepareForSearch()
              .contains(keyword.prepareForSearch()) ==
          true;
    }).toList();
  }

  ///
  /// Thực hiện filter Category
  ///
  void filterCategoryAction(InventoryItemCategoryModel category) {
    if (categorySelected.value.contains(category)) {
      categorySelected.value = [];
    } else {
      categorySelected.value = [category];
    }
    for (var item in inventoryItemCategories) {
      if (item.code != category.code) {
        item.isSelected = false;
      }
    }
  }
}
