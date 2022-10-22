import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/filter_widget.dart';

class BaseReportPage extends StatelessWidget {
  const BaseReportPage({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
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
          "Báo cáo thu chi",
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
            color: AppColors.blue,
            child: Row(
              children: [
                FilterWidget(
                  title: 'Tháng này',
                  value: '01/10/2021 - 31/10/2021',
                  imageAssetName: AppResource.icCalendar,
                ),
                AppConstant.spaceHorizontalMediumExtra,
                FilterWidget(
                  title: 'Tháng này',
                  value: '01/10/2021 - 31/10/2021',
                  imageAssetName: AppResource.icCalendar,
                ),
              ],
            ),
          ),
          child
        ],
      ),
    );
  }
}
