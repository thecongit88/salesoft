import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
    required this.title,
    this.onBackAction,
  }) : super(key: key);

  final String title;
  final Function()? onBackAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      backgroundColor: AppColors.blue,
      centerTitle: false,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 40.h);
}
