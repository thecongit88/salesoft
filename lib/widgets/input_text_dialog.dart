import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

/// benefits_dialog.dart
/// quyền lợi cộng tác viên
///
/// Created by TTLoi on 25/10/2020. Copyright © ECO3D Company 2020.
/// ----------------------------------------------------------------------------
class InputTextDialog extends StatefulWidget {
  final String title;
  final String value;
  final Function(String) callback;

  const InputTextDialog(
      {Key? key, required this.title, required this.callback, this.value = ''})
      : super(key: key);

  @override
  _InputTextDialogState createState() => _InputTextDialogState();
}

class _InputTextDialogState extends State<InputTextDialog> {
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
    _controller.text = widget.value;
    return new AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.title}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.5.sp),
            ),
            AppConstant.spaceVerticalSmallMedium,
            CupertinoTextField(
              focusNode: _focusNode,
              controller: _controller,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              autofocus: true,
              clearButtonMode: OverlayVisibilityMode.editing,
              minLines: 3,
              maxLines: 3,
              style: TextStyle(color: AppColors.grey, fontSize: 15.sp),
            ),
            AppConstant.spaceVerticalSmallMedium,
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
                        onPress: () {
                          widget.callback.call(_controller.text);
                          Get.back();
                        },
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
}
