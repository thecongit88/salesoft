import 'package:get/get.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/model/product_info_model.dart';

class KiemKhoSanPhamController extends GetxController with StateMixin<ProductInfoModel> {
  @override
  void onInit() {
    super.onInit();
  }

  ///
  /// Lấy chi tiết sản phẩm trong kho
  ///
  void getProductDetailInKho(String code) async {
    final IReportRepository _repository = Get.find();
    change(null, status: RxStatus.loading());

    final List<ProductInfoModel>? result = await _repository.getProductDetailInKho(code);
    final ProductInfoModel? productInfoModel;
    if (result != null && result.length > 0) {
      productInfoModel = result.first;
      change(productInfoModel, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }
}
