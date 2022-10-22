import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

class AppBarPriceListWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPriceListWidget({
    Key? key,
    required this.title,
    this.onBackAction,
    this.onNextAction,
  }) : super(key: key);

  final String title;
  final Function()? onBackAction;
  ///nếu onNextAction == null thì ko hiển thị nút Sau
  final Function()? onNextAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blue,
      leading: InkWellWidget(
        child: SizedBox(
          height: kToolbarHeight,
          width: 80,
          child: Row(
            children: [
              SizedBox(width: 15,),
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18,
              ),
              Expanded(
                child: Text(
                  'Trước',
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        onPress: onBackAction
      ),
      leadingWidth: 80,
      title: Text('$title'),
      centerTitle: true,
      actions: [
        onNextAction != null
            ?
        InkWellWidget(
          child: SizedBox(
            height: kToolbarHeight,
            width: 80,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Sau',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 15,)
              ],
            ),
          ),
          onPress: onNextAction,
        )
            :
        SizedBox(height: 0,)
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 55.h);
}
