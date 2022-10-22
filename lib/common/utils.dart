import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// Hiển thị Dialog
///
void showViewDialog(BuildContext context, Widget child) {
  Dialog dialog = Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r)), //this right here
    child: child,
    insetPadding: EdgeInsets.symmetric(
        horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
  );
  showDialog(context: context, builder: (context) => dialog);
}

extension Ex on double {
  double convertWithPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension ExStr on String {
  String prepareForSearch() {
    return this.toLowerCase().replaceAll("[^\\p{ASCII}]", "");
  }
}

getCurrencyFormatVND() {
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    locale: 'en',
    decimalDigits: 0,
    symbol: '',
  );
  return formatter;
}

formatQuanlity(_value) {
  double value = double.parse(_value.toString());
  final formatCurrency = new NumberFormat("#,##0.##", "en_US");
  return "${formatCurrency.format(value)}";
}

getNullOrEmptyValue(value) {
  return value != null && value != "null" && value.trim() != "" && value.trim() != "null" ? value : "-";
}

openUrl(String url) async {
  try {
    bool isGoogleLink = url.contains("drive.google.com/drive") ?  true : false;
    if (Platform.isIOS) {
      if(isGoogleLink) {
        await launch(url, forceSafariVC: false, forceWebView: true, enableJavaScript: true);
      } else {
        await launch(url, forceSafariVC: false);
      }
    } else {
      if(isGoogleLink) {
        await launch(url, forceWebView: true, enableJavaScript: true);
      } else {
        await launch(url);
      }
    }
  } catch (e) {
    await launch(url, forceSafariVC: false, forceWebView: true,
        enableJavaScript: true);
  }
}

bool hasValidUrl(String myURL) {
  var matchCaseOne = new RegExp("^(http[s]?:\\/\\/(www\\.)?|ftp:\\/\\/(www\\.)?|www\\.){1}([0-9A-Za-z-\\.@:%_\+~#=]+)+((\\.[a-zA-Z]{2,3})+)(/(.)*)?(\\?(.)*)?", caseSensitive: false).firstMatch(myURL);
  var matchCaseTwo = new RegExp("^([0-9A-Za-z-\\.@:%_\+~#=]+)+((\\.[a-zA-Z]{2,3})+)(/(.)*)?(\\?(.)*)?", caseSensitive: false).firstMatch(myURL);
  if(matchCaseOne !=null || matchCaseTwo !=null){
    return true;
  }else{
    return false;
  }
}

wdgCopyElm(String value) {
  return InkWell(
    onTap: () {
      Clipboard.setData(ClipboardData(text: value));
      Fluttertoast.showToast(
          msg: "Đã sao chép",
          gravity: ToastGravity.CENTER
      );
    },
    child: Icon(Icons.copy_rounded, size: 15, color: AppColors.grey300,),
  );
}

wdgCopyText(Widget element, String value) {
  return value.trim() != "-" && value.trim() != "" ?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  element,
                  SizedBox(width: 8),
                  wdgCopyElm(value)
                ],
              ) :
              Text("-");
}

showQty(var value) {
  var value_arr = value.toString().split(".");
  if(value_arr.length > 1 && int.parse(value_arr[1]) == 0) {
    return value_arr[0];
  }
  return value;
}

formatCurrency(_value) {
  double value = double.parse(_value.toString());
  final formatCurrency = new NumberFormat("#,##0", "en_US");
  return "${formatCurrency.format(value)}";
}

getNullValue(value) {
  return value == null || value == "null" ? 0.0 : double.parse(value.toString());
}