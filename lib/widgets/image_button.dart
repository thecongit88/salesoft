import 'package:flutter/cupertino.dart';
import 'package:sale_soft/common/app_colors.dart';

import 'inkwell_widget.dart';

class ImageButton extends StatelessWidget {
  final String assetName;
  final Function()? onTap;
  final double width;
  final double height;
  final EdgeInsets? padding;

  const ImageButton({
    Key? key,
    required this.assetName,
    this.onTap,
    this.width = 16,
    this.height = 16,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onTap,
      padding: padding ?? EdgeInsets.all(4),
      borderRadius: (width / 2) + 4,
      child: Image.asset(
        assetName,
        fit: BoxFit.fill,
        color: AppColors.grey400,
        width: width,
        height: height,
      ),
    );
  }
}
