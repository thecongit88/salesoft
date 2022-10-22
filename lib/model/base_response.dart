import 'package:get/get_connect.dart';

class BaseResponse extends Response {
  bool isSuccess() {
    return statusCode == 200;
  }

  bool hasData() {
    return body != null;
  }
}
