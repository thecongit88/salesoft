import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/order_detail_model.dart';

class ReceiptDetailController extends GetxController
    with StateMixin<List<OrderDetailModel>> {

  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  String code = ""; String? retConfirmOrder;

  List<OrderDetailModel> listData = [];
  final IReportRepository _repository = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //getOrderDetail();
  }

  /*Future<void> getOrderDetailBak() async {
    code = code.replaceAll("/", "~");
    final result = await _repository.getOrderDetail(code);
    if (result?.isNotEmpty == true) {
      listData.clear();
      listData.addAll(result ?? []);
      change(listData, status: RxStatus.success());
    } else {
      change([], status: RxStatus.empty());
    }
  }*/

 void getOrderDetail({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      change(null, status: RxStatus.loading());
      this.listData = [];
      refreshController.resetNoData();
    } else {}

    code = code.replaceAll("/", "~");
    final result = await _repository.getOrderDetail(code);

    if (result?.isNotEmpty == true) {
      listData.addAll(result ?? []);
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }

    change(listData,
        status: listData.isEmpty ? RxStatus.empty() : RxStatus.success());
  }

  confirmOrder(String orderCode) async {
    retConfirmOrder = await _repository.confirmOrder(orderCode);
    return retConfirmOrder;
  }
}