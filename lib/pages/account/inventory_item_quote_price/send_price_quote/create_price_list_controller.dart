import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/model/inventory_item_category_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/params/get_inventory_items_param.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:collection/collection.dart';
import 'package:sale_soft/model/price_list_object.dart';
import 'package:sale_soft/model/price_list_option.dart';
import 'package:sale_soft/model/price_quote_cart_model.dart';

class PriceListObjectArgument {
  PriceListObject? priceListObject;
  PriceListObjectArgument({this.priceListObject});
}

class CreatePriceListController extends GetxController
    with StateMixin<String?> {

  final myEmail = TextEditingController();
  final myPassword = TextEditingController();
  final myEmailCC = TextEditingController();

  final isEmailCaNhan = false.obs;
  var password = ''.obs;

  //data
  PriceListObjectArgument? argument;

  /// Repository
  final IReportRepository _repository = Get.find();
  String? contentMessage, resultSendBaoGia;

  var passwordVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments;
    getMessageBaoGia();
  }

  setIsEmailCaNhan(bool val) {
    isEmailCaNhan.value = val;
    update();
  }

  void getMessageBaoGia() async {
    change(contentMessage, status: RxStatus.loading());
    contentMessage =
        await _repository.getMessageBaoGia(argument!.priceListObject!);
    contentMessage = contentMessage?.replaceAll("{br}", "") ?? "";
    change(contentMessage, status: RxStatus.success());
  }

  sendBaoGia(PriceListObject priceListObject) async {
    change(resultSendBaoGia, status: RxStatus.loading());
    resultSendBaoGia =
    await _repository.sendBaoGia(priceListObject);
    if(resultSendBaoGia == "1" || int.tryParse(resultSendBaoGia.toString()) == 1) {
      showNotify("Gửi báo giá thành công!", AppConstant.success);
    } else {
      showNotify("Gửi báo giá không thành công! Vui lòng liên hệ với quản trị.", AppConstant.error);
    }
    change(resultSendBaoGia, status: RxStatus.success());
  }

  void togglePassword() {
    this.passwordVisible.value = !this.passwordVisible.value;
    update();
  }

  bool getPasswordVisible() {
    return this.passwordVisible.value;
  }

  showNotify(String msg, String typeDialog) {
    return Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Icon(typeDialog == AppConstant.success ? Icons.check_circle : Icons.error, color: typeDialog == AppConstant.success ? AppColors.green : AppColors.red, size: 45.sp,),
          content: Text("$msg", style: TextStyle(color: Colors.black87, height: 1.5), textAlign: TextAlign.center,),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
      );
  }
}
