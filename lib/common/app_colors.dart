import 'package:flutter/material.dart';

///
/// File định nghĩa các màu mè ở đây
///
class AppColors {
  static final main = Color(0xFFFEC6716);
  static final greyBackground = Color(0xFFFBFBFB);

  static final blue = Color(0xFF0873AC);
  static final blue50 = Color(0xFFE6EFF4);
  static const blue100 = Color(0xFFE6EFF4);
  static final blue150 = Color(0xFFADE2FF);
  static final blue200 = Color(0xFF53B5E9);
  static final blue400 = Color(0xFF2696D2);

  static final turquoise = Color(0xFF0CA6A2);

  static final orange = Color(0xFFEC6716);

  static final red = Color(0xFFFB3636);
  static final approved = Color(0xFFe5293e);

  static final green = Color(0xFF4AB55B);
  static final greenQuotePrice = Color(0xFF81b364);
  static final job = Color(0xFF2161cb);

  static final yellow = Color(0xFFE3AB06);
  static final yellow400 = Color(0xFFC8C32E);

  static final grey = Color(0xFF555555);
  static final grey50 = Color(0xFFC4C4C4);
  static final grey60 = Color(0xFFE9E9E9);
  static final grey300 = Color(0xFF999999);
  static final grey400 = Color(0xFF828282);
  static final grey450 = Color(0xFF888888);
  static final grey700 = Color(0xFF333333);

  static final notifi_color_1 = Color(0xffEC6716);
  static final notifi_color_2 = Color(0xff05B9B3);
  static final notifi_color_3 = Color(0xff6522EB);
  static final notifi_color_4 = Color(0xffE3AB06);
  static final notifi_color_5 = Color(0xff0873AC);
  static final notifi_color_6 = Color(0xffEC6716);


  static final orHeadTitle = Color(0xff5e5e6a);
  static final orPrice = Color(0xff4c4b59);
  static final orMainTitle = Color(0xff130810);
  static final orTime = Color(0xff5364e6);
  static final orBgr = Color(0xffeeeff4);

  static final orPending = Color(0xfffebd19);
  static final orBgPending = Color(0xffffff9e9);
  static final orCompleted = Color(0xff3ad999);
  static final orBgCompleted = Color(0xffebfcf4);
  static final orCanceled = Color(0xff4d4b59);
  static final orBgCanceled = Color(0xffefefef);
  static final orNoQuaHan = Color(0xffef4548);
  static final orBgNoQuaHan = Color(0xffffeded);

  static final orItemDetailBg = Color(0xfff5f6fa);
  static final orItemDetailProduct = Color(0xff9da5b8);

  static getDebtColor(double value) {
    return value >= 0 ? AppColors.green : AppColors.red;
  }

  //dành cho chứng từ
  static getOrderStatusBgColor(String text) {
    text = text.toString().toUpperCase();
    if(text == "ĐẶT HÀNG" || text == "ĐANG CHỜ" || text == "CHƯA XUẤT") return Colors.orangeAccent;
    else if(text == "HOÀN THÀNH") return AppColors.green;
    else if(text == "NỢ QUÁ HẠN") return AppColors.orNoQuaHan;
    else return AppColors.orCanceled;
  }

  //dành cho phiếu xuất kho, xuất hàng (hóa đơn xuất)
  static getStatusBgColorHoaDonXuat(double tinhTrang) {
    if(tinhTrang == 0) return AppColors.orange; //chưa duyệt
    else if(tinhTrang == 1) return AppColors.turquoise; //đã duyệt
    else if(tinhTrang == 2) return AppColors.green; //X/N kho
    else return AppColors.orCanceled;
  }

  static Widget pleaseWait({double size = 16, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(color: color ?? AppColors.red,)
      ),
    );
  }
}
