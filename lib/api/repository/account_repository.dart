import 'package:sale_soft/api/provider/account_provider.dart';
import 'package:sale_soft/model/app_info.dart';
import 'package:sale_soft/model/base_model.dart';
import 'package:sale_soft/model/company_info.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/login_param.dart';

abstract class IAccountRepository {
  /// Login
  Future<LoginResponseModel?> login(LoginParam param);

  /// Lấy thông tin port
  Future<String?> getPort();

  /// Lấy thông tin app
  Future<AppInfoModel?> getAppInfo();
  Future<List<CompanyInfoModel>?> getCompanyInfo();
}

class AccountRepository implements IAccountRepository {
  final IAccountProvider provider;

  AccountRepository({
    required this.provider,
  });

  @override
  Future<LoginResponseModel?> login(LoginParam param) async {
    final response = provider.login(param);

    return response.then<LoginResponseModel?>((value) {
      if (value != null) {
        //print("json logged");
        //print(value);
        return Future<LoginResponseModel>.value(
            LoginResponseModel.fromMap(value));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });

  }

  @override
  Future<String?> getPort() async {
    return provider.getPort();
  }

  @override
  Future<AppInfoModel?> getAppInfo() {
    final response = provider.getAppInfo();

    return response.then<AppInfoModel?>((value) {
      if (value != null) {
        return Future<AppInfoModel>.value(AppInfoModel.fromMap(value));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<CompanyInfoModel>?> getCompanyInfo() async {
    final response = provider.getCompanyInfo();

    return response.then<List<CompanyInfoModel>?>((value) {
      if (value != null) {
        final stores = BaseModel.listFromJson<CompanyInfoModel>(
            value, (dataMap) => CompanyInfoModel.fromMap(dataMap));

        return Future<List<CompanyInfoModel>>.value(stores);
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }
}
