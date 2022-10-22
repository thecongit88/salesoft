import 'package:sale_soft/resources/resources.dart';

enum EUserMoreAction { info, logout }

extension UserMoreActionExt on EUserMoreAction {
  String get title {
    switch (this) {
      case EUserMoreAction.info:
        return "Thông tin";
      case EUserMoreAction.logout:
        return "Đăng xuất";
    }
  }

  String get imageName {
    switch (this) {
      case EUserMoreAction.info:
        return AppResource.icUser;
      case EUserMoreAction.logout:
        return AppResource.icLogout;
    }
  }
}
