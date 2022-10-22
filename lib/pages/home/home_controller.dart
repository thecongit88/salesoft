import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var headerTypeSelected = EHeaderFunctionType.software.obs;
}

enum EHeaderFunctionType { software, marketing, question }

extension EHeaderFunctionTypeExt on EHeaderFunctionType {
  int get value {
    switch (this) {
      case EHeaderFunctionType.software:
        return 0;
      case EHeaderFunctionType.marketing:
        return 1;
      case EHeaderFunctionType.question:
        return 2;
    }
  }
}
