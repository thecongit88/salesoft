import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/build_config.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/enum/enum_user_action.dart';
import 'package:sale_soft/model/app_info.dart';
import 'package:sale_soft/model/company_info.dart';
import 'package:sale_soft/pages/account/account_controller.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/circle_image_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
          vertical: AppConstant.kSpaceVerticalSmallExtraExtraExtra),
      child: Row(
        children: [
          CircleImageWidget(
            url:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/220px-User_icon_2.svg.png',
            width: 40,
          ),
          AppConstant.spaceHorizontalSmallLarge,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: AppColors.grey),
                ),
                AppConstant.spaceVerticalVerySmall,
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: AppColors.grey),
                )
              ],
            ),
          ),
          _UserOptionWidget(),
          AppConstant.spaceHorizontalSmallExtraExtra
        ],
      ),
    );
  }
}

class _UserOptionWidget extends StatelessWidget {
  const _UserOptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find();

    return DropdownButton<EUserMoreAction>(
      underline: SizedBox.shrink(),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppResource.icUserFill,
            width: 30.r,
          ),
          Image.asset(
            AppResource.icPolygon,
            width: 30.r,
          ),
        ],
      ),
      items: <EUserMoreAction>[EUserMoreAction.info, EUserMoreAction.logout]
          .map((EUserMoreAction value) {
        return DropdownMenuItem<EUserMoreAction>(
          value: value,
          child: Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                      color: AppColors.blue,
                      // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      shape: BoxShape.circle),
                  child: Image.asset(
                    value.imageName,
                    color: Colors.white,
                    width: 12.r,
                    height: 12.r,
                    fit: BoxFit.fill,
                  )
              ),
              AppConstant.spaceHorizontalSmallExtra,
              Text(
                value.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (menuItem) async {
        if(menuItem == EUserMoreAction.logout) {
          controller.logoutAction();
        } else {
          final companyInfo = await SharedPreferencesCommon.getCompanyInfo();
          Get.dialog(
              Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    //height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                    ),
                    padding: EdgeInsets.all(15),
                    child: companyInfo == null ?
                        Center(
                          child: Text("Thông tin doanh nghiệp chưa có trong bộ nhớ tạm."),
                        )
                    :
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${companyInfo.name}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(color: AppColors.grey, fontSize: 21.sp),
                            textAlign: TextAlign.center,
                          ),
                          AppConstant.spaceVerticalMediumExtra,
                          _AddressWidget(
                            title: 'Địa chỉ: ${companyInfo.address}',
                            imageAssetName: AppResource.icLocation,
                          ),
                          AppConstant.spaceVerticalSmall,
                          _AddressWidget(
                            title: 'Điện thoại: ${companyInfo.phone}',
                            imageAssetName: AppResource.icPhone,
                          ),
                          AppConstant.spaceVerticalSmall,
                          _AddressWidget(
                            title: 'Mã doanh nghiệp: ${companyInfo.key1}',
                            imageAssetName: AppResource.icEarth,
                          ),
                          AppConstant.spaceVerticalSmall,
                          _AddressWidget(
                            title: 'MST: ${companyInfo.taxcode}',
                            imageAssetName: AppResource.icTax,
                          ),
                          AppConstant.spaceVerticalSmall,
                          _AddressWidget(
                            title: 'Phiên bản: ${BuildConfig.appVersion}',
                            imageAssetName: AppResource.ic_share,
                          ),
                          AppConstant.spaceVerticalSmallMedium,
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              child: new Text("Đóng lại", style: TextStyle(fontWeight: FontWeight.bold),),
                              textColor: AppColors.blue,
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ),

              )
          );
        }
      },
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
                .bodyText1
                ?.copyWith(color: AppColors.grey),
          ),
        )
      ],
    );
  }
}
