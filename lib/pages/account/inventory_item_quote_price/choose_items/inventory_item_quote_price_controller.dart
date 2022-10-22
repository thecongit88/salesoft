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
import 'package:sale_soft/model/represent_model.dart';

class InventoryItemQuotePriceController extends GetxController
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

  //Giỏ hàng
  int totalQty = 0;
  double totalAmount = 0;
  final quotesCart = <InventroyItemModel>[].obs;

  //Thông tin khách hàng
  String customerCode = "", customerName = "", customerEmail = "", nguoiDaiDien = "", customerPhone = "";
  PriceListOption? xungDanh, daiLy, phuongThucVanChuyen, thoiGianCapHang, dieuKienThanhToan;
  String? tuXung, tienTe;
  DateTime? fromDate, toDate;
  final includeVat = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInventoryItemCategory();
    fetchInventoryItem();
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
      /*for (InventroyItemModel item in result!) {
        if(quotesCart.length > 0) {
          List<InventroyItemModel> findItems = quotesCart.where((element) => item.code == element.code).toList();
          item.soluongBaoGia = findItems.length > 0 ? findItems[0].soluongBaoGia : 0;
        }
      }*/

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

  ///Hàm tính toán khi 1 item trong danh sách báo giá hoặc 1 item giỏ hàng có sự biến đổi
  calcQuoteCart4Item(InventroyItemModel it) {
    bool found = false;
    ///lưu lại các sản phẩm đã add vào giỏ hàng
    //quotesCart.removeWhere((InventroyItemModel el) => el.code == it.code);
    ///set lại số lượng báo giá với item đã có trong giỏ hàng
    if(quotesCart.length > 0) {
      quotesCart.forEach((element) {
        if(element.code == it.code) {
          element.soluongBaoGia = it.soluongBaoGia > 0 ? it.soluongBaoGia : 0;
          found = true;
        }
      });
    }
    ///nếu không tìm thấy sản phẩm đang set báo giá thì thêm vào item giỏ hàng
    if(found == false) {
      it.orderInCart = quotesCart.length;
      it.donGiaBaoGia = it.Price!; //mặc định là giá lẻ Price, dùng để tính toán bottom Tổng ban đầu trong form price_list_item_page
      quotesCart.add(it);
    } else {
      ///nếu tìm thấy mà số lượng sp báo giá = 0 thì remove khỏi giỏ hàng
      if(it.soluongBaoGia <= 0) {
        quotesCart.removeWhere((InventroyItemModel el) => el.code == it.code);
      }
    }
    ///sắp xếp thứ tự các items trong giỏ hàng, cái nào thêm sau cùng sẽ lên trên cùng giỏ hàn
    quotesCart.sort((a, b) => b.orderInCart.compareTo(a.orderInCart));
    ///tính tổng số lượng các item trong giỏ hàng
    calcTotalInCart(quotesCart);
    ///cập nhật lại giao diện
    update();
  }

  ///Hàm tính tổng số lượng và tổng tiền trong giỏ hàng
  calcTotalInCart(List<InventroyItemModel> listItemsInCart) {
    totalQty = 0; totalAmount = 0;
    ///lấy lại tổng số lượng và tổng tiền
    listItemsInCart.forEach((InventroyItemModel it) {
      totalQty += it.soluongBaoGia;
      totalAmount += it.soluongBaoGia * it.Price!;
    });
  }
}
