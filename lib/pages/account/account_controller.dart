import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/repository/account_repository.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/common/shared_preferences_key.dart';
import 'package:sale_soft/model/company_info.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/insert_token_param.dart';
import 'package:sale_soft/model/params/login_param.dart';
import 'package:sale_soft/pages/account/user_admin_page/user_admin_controller.dart';
import 'package:sale_soft/pages/account/user_normal_page/user_normal_controller.dart';
import 'package:sale_soft/pages/login/login_controller.dart';
import 'package:sale_soft/pages/notification/notification_controller.dart';

class AccountController extends GetxController
    with StateMixin<LoginResponseModel> {
  /// Provider
  IAccountRepository _repository = Get.find();
  IReportRepository _reportRepository = Get.find();

  CompanyInfoModel? companyInfo;

  @override
  void onInit() async {
    super.onInit();
    final loginResponse = await SharedPreferencesCommon.getLoginResponse();
    change(loginResponse, status: RxStatus.success());
  }

  ///
  /// Thực hiện login
  ///
  void loginAction(LoginParam param) async {
    change(null, status: RxStatus.loading());
    ///login với 3 tham số đưa vào là username, password và mã dn
    final result = await _repository.login(param);
    ///result trả về là class LoginResponseModel chứa các thông tin kết quả đăng nhập xong mà api login trả về
    if (result != null && result.error == null) {
      ///lưu trữ thông tin sau khi đăng nhập vào bộ nhớ tạm của thiết bị
      SharedPreferencesCommon.saveLoginParam(param);
      SharedPreferencesCommon.saveLoginResponse(result);
      putToken();

      ///lưu thông tin doanh nghiệp
      getAndSaveCompanyInfo();
    }

    _reportRepository.getStores();

    change(result, status: RxStatus.success());
  }

  putToken() async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final String code = responseLogin?.code ?? "";
    final String keyLog = responseLogin?.key ?? "";

    await Firebase.initializeApp();
    FirebaseMessaging f = FirebaseMessaging.instance;
    f.getToken().then((token) {
      HttpUtil().post("/token",
          params:
              InsertTokenParam(Code: code, Token: token, Key: keyLog).toJson());
    }).catchError((error) {});
  }

  ///
  /// Action logout
  ///
  void logoutAction() {
    // isNeedClearInfoLogin = true;
    SharedPreferencesCommon.removeKey(SharedPreferencesKey.kLOGIN_RESPONSE);

    /// Xóa Controller các thông tin khi logout
    Get.delete<UserNormalController>();
    Get.delete<UserAdminController>();
    Get.delete<LoginController>();
    change(null, status: RxStatus.success());
  }

  ///
  /// Lấy thông tin doanh nghiệp
  ///
  void getAndSaveCompanyInfo() async {
    final companyInfo = await _repository.getCompanyInfo();

    if (companyInfo != null) {
      this.companyInfo = companyInfo.first;
      SharedPreferencesCommon.saveCompanyInfo(this.companyInfo!);
    }
  }
}
