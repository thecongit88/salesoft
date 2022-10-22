import 'package:sale_soft/enum/period_time.dart';
import 'package:get/get.dart';
import 'package:sale_soft/model/store.dart';
import 'package:sale_soft/common/utils.dart';

mixin FilterMixin {
  /// Kỳ báo cáo
  final listPeriodReport = EPeriodTime.values;
  var periodReportSelected = EPeriodTime.thisMonth.obs;

  List<StoreModel> stores = [];
  // Store đang chọn
  var storesSelected = <StoreModel>[].obs;

  ///
  /// Lấy title theo ds cửa hàng đang chọn
  ///
  String getStoresTitle() {
    final count = storesSelected.value.length;
    if (count > 0) {
      return "${count} cửa hàng";
    } else {
      return "Toàn chuỗi";
    }
  }

  ///
  /// Thực hiện filter cửa hàng
  ///
  void filterStoresAction() {
    storesSelected.value =
        stores.where((element) => element.isSelected == true).toList();
  }

  ///
  /// Tìm kiếm cửa hàng theo tên
  ///
  List<StoreModel> searchStoreByKey(String keyword) {
    return stores.where((element) {
      print(
          "Key1 ${element.name?.prepareForSearch()} - Key2 ${keyword.prepareForSearch()}");
      return element.name
              ?.prepareForSearch()
              .contains(keyword.prepareForSearch()) ==
          true;
    }).toList();
  }
}
