import 'package:sale_soft/common/shared_preferences_key.dart';
import 'package:sale_soft/model/app_info.dart';
import 'package:sale_soft/model/company_info.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/login_param.dart';
import 'package:sale_soft/model/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCommon {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ///
  /// Lưu lại thông tin login
  ///
  static Future<void> saveLoginParam(LoginParam param) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(SharedPreferencesKey.kLOGIN_PARAM, param.toJson());
  }

  ///
  /// Get thông tin login
  ///
  static Future<LoginParam?> getLoginParam() async {
    final SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(SharedPreferencesKey.kLOGIN_PARAM);
    if (data?.isNotEmpty == true) {
      return LoginParam.fromJson(data ?? '');
    }
  }

  ///
  /// Lưu thông tin khi login thành công
  ///
  static Future<void> saveLoginResponse(LoginResponseModel response) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(SharedPreferencesKey.kLOGIN_RESPONSE, response.toJson());
  }

  ///
  /// Lấy thông tin Login
  ///
  static Future<LoginResponseModel?> getLoginResponse() async {
    final SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(SharedPreferencesKey.kLOGIN_RESPONSE);
    if (data?.isNotEmpty == true) {
      return LoginResponseModel.fromJson(data ?? '');
    }
  }

  ///
  /// Lưu danh sách cửa hàng
  ///
  static Future<void> saveStores(List<StoreModel> stores) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(SharedPreferencesKey.kSTORES, StoreModel.encode(stores));
  }

  ///
  /// Get stores
  ///
  static Future<List<StoreModel>?> getStores() async {
    final SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(SharedPreferencesKey.kSTORES);
    if (data?.isNotEmpty == true) {
      return StoreModel.decode(data ?? '');
    }
  }

  ///
  /// Lấy thông tin app
  ///
  static Future<AppInfoModel?> getAppInfo() async {
    final SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(SharedPreferencesKey.kAPP_INFO);
    if (data?.isNotEmpty == true) {
      return AppInfoModel.fromJson(data ?? '');
    }
  }

  ///
  /// Lưu thông tin app
  ///
  static Future<void> saveAppInfo(AppInfoModel appInfo) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(SharedPreferencesKey.kAPP_INFO, appInfo.toJson());
  }

  ///
  /// Lấy thông tin doanh nghiệp
  ///
  static Future<CompanyInfoModel?> getCompanyInfo() async {
    final SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(SharedPreferencesKey.kCOMPANY_INFO);
    if (data?.isNotEmpty == true) {
      return CompanyInfoModel.fromJson(data ?? '');
    }
  }

  ///
  /// Lưu thông tin doanh nghiệp
  ///
  static Future<void> saveCompanyInfo(CompanyInfoModel comInfo) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(SharedPreferencesKey.kCOMPANY_INFO, comInfo.toJson());
  }

  ///
  /// Xóa thông tin cache theo key
  ///
  static void removeKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(key);
  }
}
