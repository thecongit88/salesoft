import 'package:get/get.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/item_in_stock_model.dart';
import 'package:sale_soft/model/login_response_model.dart';

class InventoryItemInStockController extends GetxController
    with StateMixin<List<ItemInStockModel>> {
  InventroyItemModel inventroyItemModel = InventroyItemModel();
  List<ItemInStockModel> listData = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    var response = await HttpUtil()
        .get("${UrlHelper.ITEM_IN_STOCK}/${inventroyItemModel.code}/$key")
        .then((value) {
      if (value != null) {
        return Future<List<ItemInStockModel>>.value(
            ItemInStockModel.listFromJson(value));
      } else {
        return Future<List<ItemInStockModel>>.value(
            ItemInStockModel.listFromJson(""));
      }
    });
    if (response.isNotEmpty) {
      listData.clear();
      listData.addAll(response);
      change(listData, status: RxStatus.success());
    } else {
      change([], status: RxStatus.success());
    }
  }
}
