import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:sale_soft/api/provider/report_provider.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/pages/account/account_controller.dart';
import 'package:sale_soft/pages/account/user_admin_page/user_admin_page.dart';
import 'package:sale_soft/pages/account/user_normal_page/user_normal_page.dart';
import 'package:sale_soft/pages/account/ware_house_page/ware_house_page.dart';
import 'package:sale_soft/pages/login/login_page.dart';
import 'package:get/get.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _initBinding();

    return controller.obx((loginResponse) {
      print("Congnt Login Response");
      print(json.encode(loginResponse));
      if (loginResponse != null && loginResponse.error == null) {
        if (loginResponse.userType.toString().toUpperCase().trim() == AppConstant.loginAdmin.toUpperCase()) {
          return UserAdminPage();
        } else if (loginResponse.userType.toString().toUpperCase().trim() == AppConstant.loginWareHouse.toUpperCase()) {
          return WareHousePage();
        }
        else {
          return UserNormalPage();
        }
      } else {
        if (loginResponse?.error?.isNotEmpty == true) {
          showErrorToast(loginResponse?.error ?? '');
        }
        //chuyển đến trang đăng nhập
        return LoginPage(
          loginAction: (param) {
            final AccountController controller = Get.put(AccountController());
            controller.loginAction(param);
          },
        );
      }
    });
  }

  void _initBinding() {
    Get.lazyPut(() => AccountController());
    Get.lazyPut<IReportProvider>(() => ReportProviderAPI());
    Get.lazyPut<IReportRepository>(
        () => ReportRepository(provider: Get.find()));
  }
}
