import 'package:flutter/cupertino.dart';
import 'package:sale_soft/common/app_colors.dart';

class LineWidget extends StatelessWidget {
  const LineWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(
      //     horizontal: AppConstant.kSpaceHorizontalSmallMedium),
      width: 1,
      height: 16,
      color: AppColors.grey50,
    );
  }
}
