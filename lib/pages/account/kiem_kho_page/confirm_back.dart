import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/pages/account/kiem_kho_page/kiem_kho_controller.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

void confirmBackStep(BuildContext context) {
  final KiemKhoController controller = Get.find();

  Widget okButton = InkWellWidget(
    onPress: () async {
      var result = await controller.createKiemKho();
      if(result == "1" || result == 1) {
        showSuccessToast("Kiểm kho thành công.");
      } else {
        showErrorToast("Có lỗi khi tạo kiểm kho.");
      }
      Get.back();
      controller.setDocumentActive();
    },
    child: Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          shape: BoxShape.rectangle),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.save, size: 15, color: Colors.white,),
          AppConstant.spaceHorizontalSmallExtra,
          Text(
            "Quay về và lưu dữ liệu",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );

  Widget cancelButton = InkWellWidget(
    onPress: () async {
      Get.back();
      controller.setDocumentActive();
    },
    child: Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          shape: BoxShape.rectangle),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.cancel, size: 15, color: Colors.white,),
          AppConstant.spaceHorizontalSmallExtra,
          Text(
            "Quay về và không lưu dữ liệu",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    ),
  );

  Widget ignoreButton = InkWellWidget(
      onPress: () async {
        Get.back();
      },
      child: Center(
        child: Text(
          "Đóng lại",
          style: TextStyle(color: AppColors.grey300), textAlign: TextAlign.center,
        ),
      )
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    actionsAlignment: MainAxisAlignment.center,
    actionsPadding: const EdgeInsets.all(15),
    actions: [
      okButton,
      AppConstant.spaceVerticalSmallExtraExtraExtra,
      cancelButton,
      AppConstant.spaceVerticalSmallExtraExtraExtra,
      ignoreButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}