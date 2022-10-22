import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/product_info_model.dart';
import 'package:sale_soft/pages/account/kiem_kho_page/kiem_kho_sp_controller.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

enum InputNumberTypeKiemKho2 { QUANTITY, PRICE, PERCENTAGE }

class InputKiemKhoNoPlanDialog extends StatefulWidget {
  final InputNumberTypeKiemKho2 type;
  final String title;
  final double value;
  final double priceMin;
  final String? productCode;

  final Function(double, ProductInfoModel) callback;

  const InputKiemKhoNoPlanDialog({
      Key? key,
      required this.title,
      required this.callback,
      this.value = 0,
      this.type = InputNumberTypeKiemKho2.QUANTITY,
      this.priceMin = 0,
      this.productCode
    })
      : super(key: key);

  @override
  _InputKiemKhoNoPlanDialogState createState() => _InputKiemKhoNoPlanDialogState();
}

class _InputKiemKhoNoPlanDialogState extends State<InputKiemKhoNoPlanDialog> {
  final _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final controller = Get.put(KiemKhoSanPhamController());
  ProductInfoModel? itemDetailModel;

  @override
  void initState() {
    super.initState();
    controller.getProductDetailInKho(widget.productCode!);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.type == InputNumberTypeKiemKho2.QUANTITY || widget.type == InputNumberTypeKiemKho2.PRICE ? widget.value.toDouble().toAmountFormat().toString() : widget.value.toDouble().toString();
    _controller.text = _controller.text.trim() == "0" ? "" : _controller.text;
    _controller.selection = TextSelection(
        baseOffset: _controller.value.text.length,
        extentOffset: _controller.value.text.length);
    return AlertDialog(
      content: SingleChildScrollView(
        child: controller.obx((data) {
          itemDetailModel = data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("#${itemDetailModel?.code ?? "-"}",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              Divider(
                thickness: 0.25,
                color: AppColors.grey50,
                height: 25,
              ),
              Text("${itemDetailModel?.name ?? "-"}",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontSize: 15.sp, height: 1.3, color: AppColors.grey),
              ),
              AppConstant.spaceVerticalSmallMedium,
              Text("Đơn vị tính: ${itemDetailModel?.unit ?? "-"}",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontSize: 15.sp, height: 1.3, color: AppColors.grey),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlignVertical: TextAlignVertical.center,
                      focusNode: _focusNode,
                      controller: _controller,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      onSubmitted: (value) {
                        onDone();
                      },
                      inputFormatters:
                      widget.type == InputNumberTypeKiemKho2.QUANTITY || widget.type == InputNumberTypeKiemKho2.PRICE ?
                      <TextInputFormatter>[
                        getCurrencyFormatVND()
                      ]
                          : null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              Divider(
                thickness: 0.25,
                color: AppColors.grey50,
              ),
              AppConstant.spaceVerticalSmallMedium,
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWellWidget(
                          onPress: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel, color: AppColors.red, size: 16.sp,),
                              SizedBox(width: 3,),
                              Text(
                                "Hủy bỏ",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ),
                    ),
                    Expanded(
                      child: Text("|", style: TextStyle(color: AppColors.blue50), textAlign: TextAlign.center,),
                    ),
                    Expanded(
                      child: InkWellWidget(
                          onPress: onDone,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: AppColors.green, size: 16.sp,),
                              SizedBox(width: 3,),
                              Text(
                                "Đồng ý",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  void onDone() {
    try {
      var value = double.parse(_controller.text.replaceAll(RegExp('[^0-9.]'), ''));
      /*if (widget.type == InputNumberTypeKiemKho2.QUANTITY && value <= 0) {
        Fluttertoast.showToast(
            msg: "Số lượng phải lớn hơn 0.", gravity: ToastGravity.CENTER);
        return;
      }*/

      /*if (widget.type == InputNumberTypeKiemKho2.PERCENTAGE && value > 100) {
        Fluttertoast.showToast(
            msg: "Giá trị lớn nhất có thể nhập là 100%.",
            gravity: ToastGravity.CENTER);
        return;
      }*/

      if (value < 0) {
        Fluttertoast.showToast(
            msg: "Không thể nhập số nhỏ hơn 0.", gravity: ToastGravity.CENTER);
        return;
      }

      if (widget.type == InputNumberTypeKiemKho2.PRICE && value < widget.priceMin) {
        String priceMin = widget.priceMin.toAmountFormat();
        Fluttertoast.showToast(
            msg: "Không thể nhập thấp hơn giá sàn là $priceMin",
            gravity: ToastGravity.CENTER);
        return;
      }

      widget.callback.call(value, itemDetailModel!);
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Vui lòng nhập đúng định dạng số.",
          gravity: ToastGravity.CENTER);
    }
  }
}
