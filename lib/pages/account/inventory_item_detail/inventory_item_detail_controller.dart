import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/inventory_item_detail_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/invoice_model.dart';
import 'package:sale_soft/model/topsale_model.dart';

class InventoryItemDetailController extends GetxController with StateMixin<InventoryItemDetailModel> {
  ///
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  ///Đối tượng đẩy lên là 1 item trong danh mục hàng hóa
  InventroyItemModel? argument;

  /// Repository
  //final IReportRepository _repository = Get.find();

  var isExpanded = true.obs;

  InventoryItemDetailModel inventoryItemDetailModel = new InventoryItemDetailModel();

  var isAddedBaoGia = false.obs;

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments;
    fetchInventoryItemDetail();
  }

  ///
  /// Lấy chi tiết detail
  ///
  void fetchInventoryItemDetail() async {
    final IReportRepository _repository = Get.find();
    if (argument?.code == null) {
      change(null, status: RxStatus.empty());
      return;
    } else {
      change(null, status: RxStatus.loading());
    }

    final InventoryItemDetailModel? result = await _repository.getDetailInventoryItem(productCode: argument!.code!);
    //final result = await _repository.getDetailInventoryItem(productCode: '54001');

    if (result != null) {
      //dành riêng cho màn hình báo giá khi bấm vào chi tiết xem
      result.soluongBaoGia = argument?.soluongBaoGia ?? 0;
      result.giaBaoGia = argument?.Price ?? 0; //giá báo giá là giá lẻ Price, lưu ý
      //end dành riêng cho màn hình báo giá khi bấm vào chi tiết xem
      change(result, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
    refreshController.refreshCompleted();
  }
}
