import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/build_config.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/company_info.dart';
import 'package:sale_soft/pages/notification/notification_controller.dart';
import 'package:xml/xml.dart';
import 'api/api_config/http_util.dart';
import 'api/repository/account_repository.dart';
import 'model/NotificationModel.dart';
import 'model/app_info.dart';
import 'package:launch_review/launch_review.dart';

import 'model/login_response_model.dart';
import 'model/params/insert_token_param.dart';

class MainController extends GetxController with StateMixin<bool> {
  var pageIndex = 0.obs;
  AppInfoModel? appInfo;

  final IAccountRepository _repository = Get.find();

  var listNotificationUnread = [];

  @override
  void onInit() {
    super.onInit();

    //getPort();
    getAppInfo();
    putToken();
    getListNotification();
  }

  getListNotification() async {
    await Firebase.initializeApp();

    await getNotification().then((response) {
      listNotificationUnread.clear();
      if (response.isNotEmpty) {
        listNotificationUnread
            .addAll(response.where((element) => element.Status == 0).toList());
        change(true, status: RxStatus.success());
      } else {
        change(true, status: RxStatus.success());
      }
    });
  }

  Future<List<NotificationModel>> getNotification() async {
    return await FirebaseMessaging.instance.getToken().then(
      (token) async {
        NotificationParam param = NotificationParam(Code: 1, Token: token)
            // "eU-raz23R0oZqKh9uHeqLA:APA91bH6DyN6qt7T0TzSkod3UuAe6TF-rPjBf4JGhT38b0eZ0SVGqFm_vSGyvAtYqwLCsfVTOYhnZG-FIHE2_4vg79v9hLII23hWiF_HJ6BNYycGw0x2Br7Y2E4faL97eeTlZVrOSy5T")
            ;
        return HttpUtil()
            .post("${UrlHelper.LIST_NOTIFI}", params: param.toJson())
            .then<List<NotificationModel>>((value) {
          if (value != null) {
            return Future<List<NotificationModel>>.value(
                NotificationModel.listFromJson(value));
          } else {
            return Future<List<NotificationModel>>.value(<NotificationModel>[]);
          }
        });
      },
    );
  }

  ///
  /// Lấy thông tin app
  ///
  Future<void> getAppInfo() async {
    final appInfo = await _repository.getAppInfo();
    if (appInfo != null) {
      this.appInfo = appInfo;
      SharedPreferencesCommon.saveAppInfo(appInfo);
    }

    /// Xử lý nâng cấp version
    final versionServer = int.tryParse(appInfo?.appVersion ?? "");

    if (versionServer != null && versionServer > BuildConfig.appVersion) {
      Get.defaultDialog(
          title: "Thông báo",
          barrierDismissible: false,
          onConfirm: () {
            LaunchReview.launch(
                androidAppId: BuildConfig.iOSApandroidAppIdpId,
                iOSAppId: BuildConfig.iOSAppId);
          },
          textConfirm: "Đồng ý",
          middleText: "Phiên bản hiện tại là ${BuildConfig.appVersion} đã cũ. Bạn phải cập nhật phiên bản mới để tiếp tục sử dụng.");
      change(true, status: RxStatus.empty());
    } else {
      change(true, status: RxStatus.success());
    }
  }

  ///
  /// Lấy thông tin port
  ///
  void getPort() async {
    final content = await _repository.getPort();

    if (content != null) {
      try {
        final document = XmlDocument.parse(content);
        final urlServer =
            document.findAllElements('Server').toList().first.text;
        final portServer = document.findAllElements('Port').toList().first.text;

        UrlHelper.baseUrl = urlServer;
        UrlHelper.port = portServer;
        print(urlServer);
        print(portServer);
      } on Exception catch (_) {
        print('Parse XML port faild!');
      }
    }
  }

  void putToken() async {
    // print("PutToken info")
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    if (responseLogin != null) {
      final String code = responseLogin.code ?? "";
      final String keyLog = responseLogin.key ?? "";

      await Firebase.initializeApp();
      FirebaseMessaging f = FirebaseMessaging.instance;
      f.getToken().then((token) {
        HttpUtil().post("/token",
            params: InsertTokenParam(Code: code, Token: token, Key: keyLog)
                .toJson());
      }).catchError((error) {});
    }
  }
}
