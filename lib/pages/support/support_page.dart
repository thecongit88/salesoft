import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/contact_model.dart';
import 'package:sale_soft/pages/support/support_controller.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SupportPageState();
  }
}

class SupportPageState extends State<SupportPage>
    with AutomaticKeepAliveClientMixin<SupportPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.put(SupportController());
    return controller.obx((listContact) {
      return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: () => {controller.getListSupport()},
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bindContactDataByType(
                      1,
                      listContact!
                          .where((element) => element.Type == 1)
                          .toList()),
                  bindContactDataByType(
                      2,
                      listContact
                          .where((element) => element.Type == 2)
                          .toList()),
                  bindContactDataByType(
                      3,
                      listContact
                          .where((element) => element.Type == 3)
                          .toList()),
                  _CompanyInfoWidget(),
                  BankAccountWidget(),
                  SizedBox(
                    height: AppConstant.kSpaceVerticalLarge,
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
        onEmpty: EmptyDataWidget(
          onReloadData: () => {controller.getListSupport()},
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget bindContactDataByType(int type, List<ContactModel> data) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    (Text(getSupportTypeTitle(type)!,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
    SizedBox(
      height: AppConstant.kSpaceVerticalSmallExtraExtra,
    ),
    SizedBox(
      height: 0.15.sh,
      child: ListView.builder(
          itemCount: data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return buildContactItem(data[index])!;
          }),
    ),
    SizedBox(
      height: AppConstant.kSpaceVerticalSmallExtraExtra,
    ),
  ]);
}

Widget? buildContactItem(ContactModel data) {
  return SizedBox(
    width: 0.7.sw,
    height: 0.2.sh,
    child: Container(
      alignment: Alignment.center,
      margin:
          EdgeInsets.only(right: AppConstant.kSpaceHorizontalSmallExtraExtra),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          )),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: AppConstant.kSpaceHorizontalSmallExtraExtra,
              right: AppConstant.kSpaceHorizontalSmallExtraExtra,
            ),
            child: CircleAvatar(
              radius: 0.055.sh,
              backgroundImage: NetworkImage("${data.ImageUrl}"),
              backgroundColor: Colors.transparent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.Name ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                data.Position ?? "",
                style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                data.Phone ?? "",
                style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _CircleIconWidget(
                    imageAssetName: AppResource.sms,
                    onPress: () {
                      launch("sms:${data.Phone}");
                    },
                  ),
                  _CircleIconWidget(
                    imageAssetName: AppResource.phone,
                    onPress: () {
                      launch("tel:${data.Phone}");
                    },
                  ),
                  _CircleIconWidget(
                    imageAssetName: AppResource.zalo2,
                    onPress: () {},
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}

String? getSupportTypeTitle(int type) {
  try {
    switch (type) {
      case 1:
        return "Hỗ trợ kỹ thuật 24/7";
      case 2:
        return "Chăm sóc khách hàng";
      case 3:
        return "Tư vấn, quản lý";
    }
  } catch (e) {
    return "";
  }
}

class BankAccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SupportController controller = Get.find();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Tài khoản công ty",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
            ),
            AppConstant.spaceVerticalSmall,
            Text(
              controller.appInfo?.bankName1 ?? "",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.sp),
            ),
            AppConstant.spaceVerticalSmall,
            Text(
              "STK: ${controller.appInfo?.accNumber1 ?? ""}",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.sp),
            ),
            AppConstant.spaceVerticalSmall,
            Text(
              controller.appInfo?.accName1 ?? "",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.sp),
            ),
          ],
        )),
        Container(
          margin: EdgeInsets.only(top: 10.h),
          height: 38.h,
          width: 0.5,
          decoration: BoxDecoration(
              border: Border.all(width: 0.5.w, color: AppColors.grey50)),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Tài khoản cá nhân",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
            ),
            AppConstant.spaceVerticalSmall,
            Text(
              controller.appInfo?.bankName2 ?? "",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.sp),
            ),
            AppConstant.spaceVerticalSmall,
            Text(
              "STK: ${controller.appInfo?.accNumber2 ?? ""}",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.sp),
            ),
            AppConstant.spaceVerticalSmall,
            Text(
              "CTK: ${controller.appInfo?.accName2 ?? ""}",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.sp),
            ),
          ],
        ))
      ],
    );
  }
}

class _CompanyInfoWidget extends StatelessWidget {
  const _CompanyInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SupportController controller = Get.find();
    return Container(
      color: AppColors.greyBackground,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.appInfo?.company ?? "",
              style: Theme.of(context).textTheme.caption?.copyWith(
                  color: AppColors.grey, fontWeight: FontWeight.bold)),
          AppConstant.spaceVerticalSmall,
          _AddressWidget(
            title: controller.appInfo?.address ?? "",
            imageAssetName: AppResource.icLocation,
          ),
          _AddressWidget(
            title: controller.appInfo?.phone ?? "",
            imageAssetName: AppResource.icPhone,
          ),
          _AddressWidget(
            title:
                '${controller.appInfo?.website ?? ""} - MST: ${controller.appInfo?.taxCode ?? ""}',
            imageAssetName: AppResource.icEarth,
          )
        ],
      ),
    );
  }
}

class _AddressWidget extends StatelessWidget {
  final String title;
  final String imageAssetName;

  const _AddressWidget({
    Key? key,
    required this.title,
    required this.imageAssetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imageAssetName,
          width: 24.r,
          height: 24.r,
        ),
        AppConstant.spaceHorizontalSmall,
        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: AppColors.grey),
          ),
        )
      ],
    );
  }
}

class _CircleIconWidget extends StatelessWidget {
  final String imageAssetName;
  final Function()? onPress;

  const _CircleIconWidget({
    Key? key,
    required this.imageAssetName,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onPress,
      padding: const EdgeInsets.all(4),
      borderRadius: 20,
      child: Image.asset(
        imageAssetName,
        fit: BoxFit.fill,
        width: 24.r,
        height: 24.r,
      ),
    );
  }
}
