import 'dart:convert';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/app_info.dart';
import 'package:sale_soft/model/contact_model.dart';

class SupportController extends GetxController
    with StateMixin<List<ContactModel>> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<ContactModel> list = [];
  AppInfoModel? appInfo;

  @override
  void onInit() async {
    super.onInit();
    appInfo = await SharedPreferencesCommon.getAppInfo();
    getListSupport();
  }

  getListSupport() async {
    print("app info");
    print(json.encode(appInfo));
    List<ContactModel> response = await HttpUtil()
        .get("${UrlHelper.LIST_CONTACT}")
        .then<List<ContactModel>>((value) {
      if (value != null) {
        return Future<List<ContactModel>>.value(
            ContactModel.listFromJson(value));
      } else {
        return Future<List<ContactModel>>.value(<ContactModel>[]);
      }
    });

    if (response.isNotEmpty) {
      list.clear();
      list.addAll(response);
      refreshController.refreshCompleted();
      change(list, status: RxStatus.success());
    } else {
      refreshController.refreshFailed();
      change([], status: RxStatus.empty());
    }
  }
}
