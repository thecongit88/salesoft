import 'package:flutter/cupertino.dart';
import 'package:sale_soft/common/app_colors.dart';

///
/// Widget image border
///
class CircleImageWidget extends StatelessWidget {
  const CircleImageWidget({
    Key? key,
    required this.url,
    this.width = 40,
  }) : super(key: key);

  final String url;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(width / 2),
      child: Image.network(
        url,
        height: width,
        width: width,
        // color: AppColors.grey300,
      ),
    );
  }
}
