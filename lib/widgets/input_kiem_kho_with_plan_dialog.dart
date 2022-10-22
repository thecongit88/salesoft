import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/inventory_product_model.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

enum InputNumberTypeKiemKho { QUANTITY, PRICE, PERCENTAGE }

class InputKiemKhoWithPlanDialog extends StatefulWidget {
  final InputNumberTypeKiemKho type;
  final String title;
  final double value;
  final double priceMin;
  final InventoryProductModel? inventroyItemPlan;

  final Function(double) callback;

  const InputKiemKhoWithPlanDialog({
      Key? key,
      required this.title,
      required this.callback,
      this.value = 0,
      this.type = InputNumberTypeKiemKho.QUANTITY,
      this.priceMin = 0,
      this.inventroyItemPlan
    })
      : super(key: key);

  @override
  _InputKiemKhoWithPlanDialogState createState() => _InputKiemKhoWithPlanDialogState();
}

class _InputKiemKhoWithPlanDialogState extends State<InputKiemKhoWithPlanDialog> {
  final _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*_controller.text = widget.type == InputNumberTypeKiemKho.QUANTITY || widget.type == InputNumberTypeKiemKho.PRICE ? widget.value.toDouble().toAmountFormat().toString() : widget.value.toDouble().toString();*/
    _controller.text = widget.value.toDouble().toAmountFormat().toString();
    _controller.text = _controller.text.trim() == "0" || _controller.text.trim() == "0.0" ? "" : showQty(_controller.text.toString());
    _controller.selection = TextSelection(
        baseOffset: _controller.value.text.length,
        extentOffset: _controller.value.text.length);

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("#${widget.inventroyItemPlan?.ma ?? "-"}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            Divider(
              thickness: 0.25,
              color: AppColors.grey50,
            ),
            Text(widget.inventroyItemPlan?.ten ?? "-",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontSize: 15.sp, height: 1.3, color: AppColors.grey),
            ),
            AppConstant.spaceVerticalSmallMedium,
            Text("Số lượng hiện tại: ${showQty(widget.inventroyItemPlan?.quantity ?? 0).toString()} ${widget.inventroyItemPlan?.unit ?? "-"}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontSize: 15.sp, height: 1.3, color: AppColors.grey),
            ),
            /*AppConstant.spaceVerticalSmallMedium,
            Text("Đơn vị tính: ${widget.inventroyItemPlan?.unit ?? "-"}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontSize: 15.sp, height: 1.3, color: AppColors.grey),
            ),*/
            AppConstant.spaceVerticalSmallMedium,
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
                    inputFormatters: <TextInputFormatter>[
                      getCurrencyFormatVND()
                    ],
                    /*widget.type == InputNumberTypeKiemKho.QUANTITY || widget.type == InputNumberTypeKiemKho.PRICE ?
                    <TextInputFormatter>[
                      getCurrencyFormatVND()
                    ] : null,*/
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
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  void onDone() {
    try {
      var value = double.parse(_controller.text.replaceAll(RegExp('[^0-9.]'), ''));
      if (widget.type == InputNumberTypeKiemKho.QUANTITY && value < 0) {
        Fluttertoast.showToast(
            msg: "Số lượng phải lớn hơn 0.", gravity: ToastGravity.CENTER);
        return;
      }

      /*if (widget.type == InputNumberTypeKiemKho.PERCENTAGE && value > 100) {
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

      if (widget.type == InputNumberTypeKiemKho.PRICE && value < widget.priceMin) {
        String priceMin = widget.priceMin.toAmountFormat();
        Fluttertoast.showToast(
            msg: "Không thể nhập thấp hơn giá sàn là $priceMin",
            gravity: ToastGravity.CENTER);
        return;
      }

      widget.callback.call(value);
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Vui lòng nhập đúng định dạng số.",
          gravity: ToastGravity.CENTER);
    }
  }
}
