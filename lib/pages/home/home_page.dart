import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/pages/home/childs_page/marketing_page.dart';
import 'package:sale_soft/pages/home/childs_page/question_page.dart';
import 'package:sale_soft/pages/home/childs_page/software_page.dart';
import 'package:sale_soft/pages/home/home_controller.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final List<Widget> screens = [
    SoftwarePage(),
    MarketingPage(),
    QuestionPage()
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.put(HomeController());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _HeaderView(),
      Expanded(
        child: Obx(() => IndexedStack(
              index: controller.headerTypeSelected.value.value,
              children: widget.screens,
            )),
      ),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}

class _HeaderView extends StatelessWidget {
  const _HeaderView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Container(
      decoration: BoxDecoration(
          color: AppColors.blue50,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          shape: BoxShape.rectangle),
      margin: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
          vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
          vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeaderItemView(
                assetName: AppResource.icSoftware,
                title: "Phần mềm",
                type: EHeaderFunctionType.software,
                onPress: () {
                  controller.headerTypeSelected.value =
                      EHeaderFunctionType.software;
                },
              ),
              AppConstant.spaceHorizontalMediumExtra,
              _HeaderItemView(
                assetName: AppResource.icMarketing,
                title: "Marketing",
                type: EHeaderFunctionType.marketing,
                onPress: () {
                  controller.headerTypeSelected.value =
                      EHeaderFunctionType.marketing;
                },
              ),
              AppConstant.spaceHorizontalMediumExtra,
              _HeaderItemView(
                assetName: AppResource.icQuestion,
                title: "Hỏi đáp",
                type: EHeaderFunctionType.question,
                onPress: () {
                  controller.headerTypeSelected.value =
                      EHeaderFunctionType.question;
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _HeaderItemView extends StatelessWidget {
  final Function()? onPress;
  final String? title;
  final String? assetName;
  final EHeaderFunctionType? type;

  const _HeaderItemView({
    Key? key,
    this.onPress,
    this.title,
    required this.assetName,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return InkWellWidget(
        borderRadius: 8.0,
        onPress: onPress,
        child: Obx(
          () => Container(
            width: 80.w,
            padding:
                EdgeInsets.all(AppConstant.kSpaceHorizontalSmallExtraExtra),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(
                  color: controller.headerTypeSelected.value == type
                      ? AppColors.blue
                      : AppColors.grey50,
                ),
                shape: BoxShape.rectangle),
            child: Column(
              children: [
                Image.asset(
                  assetName ?? '',
                  width: 30.r,
                  height: 30.r,
                ),
                AppConstant.spaceVerticalSmallMedium,
                Text(
                  title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 11.sp),
                )
              ],
            ),
          ),
        ));
  }
}
