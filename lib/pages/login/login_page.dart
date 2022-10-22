import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/build_config.dart';
import 'package:sale_soft/main_controller.dart';
import 'package:sale_soft/model/params/login_param.dart';
import 'package:sale_soft/pages/login/login_controller.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
    required this.loginAction,
  }) : super(key: key);

  final Function(LoginParam) loginAction;

  @override
  Widget build(BuildContext context) {
    //final MainController mainController = Get.find();
    //print("version app info");
    //print(json.encode(mainController.appInfo));
    final controller = Get.put(LoginController());
    final userPasswordController = TextEditingController(text: controller.password.value);
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
        child: controller.obx((state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                AppResource.logo,
                height: 156.h,
              ),
              _EditText(
                title: 'Tên đăng nhập',
                value: controller.userName.value,
                onChange: (value) {
                  controller.userName.value = value;
                },
              ),
              AppConstant.spaceVerticalSmallMedium,

              /* congnt: show/hide password extra */
              _EditText(
                title: "Mật khẩu",
                value: "",
                onChange: (value) {
                  controller.password.value = value;
                },
                isHideValue: controller.getPasswordVisible(),
                controllerTF: userPasswordController,
                suffix: InkWell(
                    onTap: () => controller.togglePassword(),
                    child: Text(
                      controller.passwordVisible.value ? "HIỆN" : "ẨN",
                      style: Theme.of(context).textTheme.bodyText2
                          ?.copyWith(color: AppColors.grey300),
                      textAlign: TextAlign.center,
                    )
                ),
              ),

              /*
              _EditText(
                title: 'Mật khẩu',
                isHideValue: true,
                value: controller.password.value,
                onChange: (value) {
                  controller.password.value = value;
                },
              ),
              */

              AppConstant.spaceVerticalSmallMedium,
              _EditText(
                title: 'Mã doanh nghiệp',
                value: controller.companyCode.value,
                onChange: (value) {
                  controller.companyCode.value = value;
                },
              ),
              AppConstant.spaceVerticalMediumExtra,
              _LoginButtonWidget(
                controller: controller,
                loginAction: loginAction,
              ),

              //congnt: add text phiên bản hiện tại
              AppConstant.spaceVerticalSmallExtra,
              Align(
                child: Text(
                  'Phiên bản hiện tại là ${BuildConfig.appVersion}',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                ),
              ),

              AppConstant.spaceVerticalMediumExtra,
              Align(
                child: Text(
                  'Vui lòng liên hệ để được hỗ trợ:',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(color: AppColors.blue),
                ),
              ),
              AppConstant.spaceVerticalSmallMedium,
              _CompanyInfoWidget(),
              AppConstant.spaceVerticalSafeArea
            ],
          );
        }));
  }
}

class _LoginButtonWidget extends StatelessWidget {
  const _LoginButtonWidget({
    Key? key,
    required this.controller,
    required this.loginAction,
  }) : super(key: key);

  final LoginController controller;
  final Function(LoginParam) loginAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 44.h,
        child: Obx(() {
          return TextButton(
              onPressed: controller.isValidateInfo() ? _loginOnClick : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    controller.isValidateInfo()
                        ? AppColors.blue
                        : AppColors.grey400),
              ),
              child: Text(
                'Đăng nhập',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.white),
              ));
        }));
  }

  void _loginOnClick() {
    loginAction(controller.getLoginParam());
  }
}

class _CompanyInfoWidget extends StatelessWidget {
  const _CompanyInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtra),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CÔNG TY CỔ PHẦN TIN HỌC VÂN THANH',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: AppColors.grey)),
          AppConstant.spaceVerticalSmall,
          _AddressWidget(
            title: 'Số 67 Mạc Thị Bưởi, P.Vĩnh Tuy, Q.Hai Bà Trưng, TP.Hà Nội',
            imageAssetName: AppResource.icLocation,
          ),
          _AddressWidget(
            title: '(+84) 24.3636.0326',
            imageAssetName: AppResource.icPhone,
          ),
          _AddressWidget(
            title: 'https://salesoft.vn/ - MST: 0101899880',
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
                .bodyText1
                ?.copyWith(color: AppColors.grey),
          ),
        )
      ],
    );
  }
}

class _EditText extends StatelessWidget {
  final String title;
  final Function(String)? onChange;
  final String value;
  final bool isHideValue;
  final TextEditingController? controllerTF;
  final Widget? suffix;

  const _EditText({
    Key? key,
    required this.title,
    required this.onChange,
    required this.value,
    this.isHideValue = false,
    this.controllerTF,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controllerTF = controllerTF ?? TextEditingController(text: value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        AppConstant.spaceVerticalSmallMedium,
        TextField(
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(color: Colors.black),
          controller: _controllerTF,
          obscureText: isHideValue,
          maxLines: 1,
          // enableSuggestions: false,
          // autocorrect: false,
          onChanged: onChange,
          decoration: InputDecoration(
              fillColor: AppColors.blue100,
              filled: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                vertical: AppConstant.kSpaceVerticalSmallExtra,
              ),
              hintText: 'Chạm để nhập',
              suffix: suffix
          ),
        )
      ],
    );
  }
}