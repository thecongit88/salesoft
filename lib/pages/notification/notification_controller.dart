import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/main_controller.dart';
import 'package:sale_soft/model/NotificationModel.dart';

class NotificationController extends GetxController
    with StateMixin<List<NotificationModel>> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<NotificationModel> listNotification = [];

  List<Color> listColor = [
    AppColors.notifi_color_1,
    AppColors.notifi_color_2,
    AppColors.notifi_color_3,
    AppColors.notifi_color_4,
    AppColors.notifi_color_5,
    AppColors.notifi_color_6
  ];

  getListNotification() async {
    await getNotification().then((response) {
      if (response.isNotEmpty) {
        listNotification.clear();
        listNotification.addAll(response);
        refreshController.refreshCompleted();
        change(listNotification, status: RxStatus.success());
      } else {
        refreshController.loadNoData();
        change(listNotification, status: RxStatus.empty());
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getListNotification();
  }

  void markItemAsRead(NotificationModel notification) {
    readNotification(notification.ID ?? 0);
    listNotification
        .firstWhere((element) => notification.ID == element.ID)
        .Status = 1;
    change(listNotification, status: RxStatus.success());

    var mainController = Get.find<MainController>();
    mainController.getListNotification();
  }
}

readNotification(int id) {
  HttpUtil().get("${UrlHelper.LIST_NOTIFI}/status/$id");
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

class NotificationParam {
  int? Code; // page index
  String? Token;

  NotificationParam({required this.Code, required this.Token});

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() {
    return {
      'Code': Code,
      'Token': Token,
    };
  }
}
