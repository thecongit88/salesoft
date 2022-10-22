import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/login_param.dart';

abstract class IAccountProvider {
  Future<dynamic> login(LoginParam param);

  Future<String> getPort();

  Future<dynamic> getAppInfo();
  Future<dynamic> getCompanyInfo();
}

class AccountProviderAPI implements IAccountProvider {
  @override
  Future login(LoginParam param) async {
    final urlEndPoint =
        "${UrlHelper.LOGIN}/${param.userName}/${param.password}/${param.companyCode}";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future<String> getPort() async {
    return await HttpUtil().get(UrlHelper.urlGetPort);
  }

  @override
  Future getAppInfo() async {
    final urlEndPoint = "${UrlHelper.APP_INFO}";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getCompanyInfo() async {
    final LoginResponseModel? responseLogin =
    await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final urlEndPoint = "${UrlHelper.COMPANY_INFO}/$key";
    return await HttpUtil().get(urlEndPoint);
  }
}
