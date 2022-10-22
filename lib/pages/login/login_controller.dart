import 'package:get/get.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/login_param.dart';

class LoginController extends GetxController
    with StateMixin<LoginResponseModel> {
  var userName = ''.obs;
  var password = ''.obs;
  var companyCode = ''.obs;
  var passwordVisible = true.obs;

  @override
  void onInit() async {
    super.onInit();
    final loginInfo = await SharedPreferencesCommon.getLoginParam();
    print("ReloadData ${loginInfo.toString()}");
    userName.value = loginInfo?.userName ?? '';
    companyCode.value = loginInfo?.companyCode ?? '';
    change(null, status: RxStatus.success());
  }

  ///
  /// Validate thông tin đăng nhập
  ///
  bool isValidateInfo() {
    if (userName.value.trim().isEmpty) {
      return false;
    }

    if (password.value.trim().isEmpty) {
      return false;
    }

    if (companyCode.value.trim().isEmpty) {
      return false;
    }

    return true;
  }

  LoginParam getLoginParam() {
    return LoginParam(
        userName: userName.value,
        password: password.value,
        companyCode: companyCode.value);
  }

  void togglePassword() {
    this.passwordVisible.value = !this.passwordVisible.value;
    update();
  }

  bool getPasswordVisible() {
    return this.passwordVisible.value;
  }
}
