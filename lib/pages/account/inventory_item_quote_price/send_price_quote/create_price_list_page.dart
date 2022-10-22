import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/common/text_theme_app.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/price_list_object.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/represent/filter_represent_widget.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/send_price_quote/create_price_list_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/widgets/app_bar_price_list_widget.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/widgets/edit_html_content.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/text_form_field_widget.dart';

class CreatePriceListPage extends StatelessWidget {
  const CreatePriceListPage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CreatePriceListPage();
  }
}

class _CreatePriceListPage extends StatefulWidget {
  const _CreatePriceListPage({
    Key? key,
  }) : super(key: key);

  @override
  _CreatePriceListPageState createState() => _CreatePriceListPageState();
}

class _CreatePriceListPageState extends State<_CreatePriceListPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<CreatePriceListController>();

  @override
  Widget build(BuildContext context) {
    var loadingState = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Đang xử lý...",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: new BorderRadius.circular(6.0),
      ),
    );

    Widget btnSendBaoGia = controller.obx((state) {
      return InkWellWidget(
        onPress: () async {
          if (_formKey.currentState == null) {
            return;
          }
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final LoginResponseModel? responseLogin = await SharedPreferencesCommon.getLoginResponse();
            PriceListObject priceListObject = controller.argument!.priceListObject!;
            priceListObject.EmailNV =
            controller.isEmailCaNhan.value == true ? controller.myEmail.text : '';
            priceListObject.Password =
            controller.isEmailCaNhan.value == true ? controller.password.value : '';
            priceListObject.EmailCC = controller.myEmailCC.text;
            priceListObject.UserName = responseLogin?.code ?? "";
            priceListObject.UserEmail = responseLogin?.email ?? "";
            priceListObject.NoiDung = controller.contentMessage ?? "";
            //priceListObject.NoiDung = "test here";
            await controller.sendBaoGia(priceListObject);
          }
        },
        child: Container(
          height: 45.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              shape: BoxShape.rectangle),
          child: Text(
            "Gửi báo giá",
            style: TextStyle(color: Colors.white, fontSize: 16.5.sp),
          ),
        ),
      );
      },
      onLoading: Container(
        height: 45.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.grey300,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            shape: BoxShape.rectangle),
        child: Text(
          "Đang xử lý ...",
          style: TextStyle(color: Colors.white, fontSize: 16.5.sp),
        ),
      )
    );

    return Scaffold(
      appBar: AppBarPriceListWidget(
        title: "Thông tin báo giá",
        onBackAction: () {
          Navigator.pop(context, false);
        },
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                      children: [
                        _CheckBoxButtonWidget(
                          title: 'Sử dụng email cá nhân.',
                          onPress: (value) {
                            controller.setIsEmailCaNhan(value);
                          },
                          isChecked: controller.isEmailCaNhan,
                        ),
                        AppConstant.spaceHorizontalSmallExtra,
                        controller.obx((data) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
                              child: Visibility(
                                visible: controller.isEmailCaNhan.value,
                                child: Column(
                                  children: [
                                    AppConstant.spaceVerticalSmallExtraExtraExtra,
                                    TextFormFieldWidget(
                                      label: "E-mail cá nhân",
                                      textEditingController: controller.myEmail,
                                      onChange: (keyword) async {
                                      },
                                      isValidator: true,
                                    ),
                                    AppConstant.spaceVerticalSmallExtraExtraExtra,
                                    /*TextFormFieldWidget(
                                      label: "Mật khẩu",
                                      textEditingController: controller.myPassword,
                                      onChange: (keyword) async {
                                      },
                                      isValidator: true,
                                    ),*/

                                    _EditText(
                                      title: "Mật khẩu",
                                      value: "",
                                      onChange: (value) {
                                        controller.password.value = value;
                                      },
                                      isHideValue: controller.getPasswordVisible(),
                                      controllerTF: controller.myPassword,
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
                                  ],
                                ),
                              ),
                            );
                          },
                          onLoading: SizedBox(height: 0,)
                        ),
                        AppConstant.spaceVerticalSmallExtraExtraExtra,
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("E-mail CC",
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      maxLines: 3,
                                      style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.black, fontSize: 15.sp),
                                      controller: controller.myEmailCC,
                                      onChanged: (text) {

                                      },
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
                                          vertical: AppConstant.kSpaceVerticalSmallExtraExtraExtra,
                                        ),
                                        hintText: "customer1@gmail.com, customer2@gmail.com, ...",
                                        hintStyle: TextStyle(fontSize: 15.sp)
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      showViewDialog(
                                          context,
                                          FilterRepresentWidget(
                                            customerCode: controller.argument!.priceListObject!.Code,
                                            onDone: (item) async {
                                              Get.back();
                                              if (controller.myEmailCC.text.contains(item.Email ?? "")) return;
                                              controller.myEmailCC.text +=
                                                  (controller.myEmailCC.text.isNotEmpty == true ? ',' : '') + "${item.Email ?? ""}";
                                            },
                                          )
                                      );
                                      /*showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ChooseRepresentDialog(
                                            code: widget.priceListObject.Code,
                                            keySearch: 'all',
                                            callback: (represent) {
                                              if (_emailCC.text
                                                  .contains(represent.Email)) return;

                                              _emailCC.text +=
                                                  (_emailCC.text.isNotEmpty == true
                                                          ? ','
                                                          : '') +
                                                      represent.Email;
                                            },
                                          );
                                        },
                                      );*/
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          )
                        ),
                        Container(
                          constraints: BoxConstraints(minHeight: 300),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFe7ebed)),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                color: Color(0xFFe7ebed),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "NỘI DUNG",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            iconSize: 24,
                                            icon: Icon(Icons.edit, color: AppColors.blue,),
                                            onPressed: () {
                                              Navigator.push(context,
                                                CupertinoPageRoute(
                                                    builder: (context) {
                                              return EditHtmlContent(
                                                value: controller.contentMessage ?? "",
                                                callback: (value) {
                                                  controller.contentMessage = value;
                                                  controller.update();
                                                },
                                              );
                                            }));
                                            },
                                          ),
                                          IconButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            iconSize: 24,
                                            icon: Icon(Icons.refresh, color: AppColors.blue),
                                            onPressed: () {
                                              controller.getMessageBaoGia();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: controller.obx((data) {
                                  return HtmlWidget(
                                      controller.contentMessage ?? "",
                                      textStyle: TextStyle(fontWeight: FontWeight.normal, height: 1.6)
                                  );
                                },
                                onLoading: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: CircularProgressIndicator(),
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: btnSendBaoGia,
              ),
            ],
          ),
        ),
      )
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
    final controller = Get.find<CreatePriceListController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextThemeApp.wdgTitle(title),
        SizedBox(height: 8),
        TextFormField(
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
          validator: (value) {
            if (value != null && value.isEmpty && controller.isEmailCaNhan.value == true) {
              return "Thông tin bắt buộc.";
            }
            return null;
          },
        )
      ],
    );
  }
}

class _CheckBoxButtonWidget extends StatelessWidget {
  const _CheckBoxButtonWidget({
    Key? key,
    required this.title,
    required this.isChecked,
    this.onPress,
  }) : super(key: key);

  final String title;
  final RxBool isChecked;
  final Function(bool value)? onPress;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: () {
        isChecked.value = !isChecked.value;
        if (onPress != null) {
          onPress!(isChecked.value);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
        child: Row(
          children: [
            Obx(() {
              return Icon(
                isChecked.value
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: AppColors.blue,
              );
            }),
            AppConstant.spaceHorizontalSmallExtra,
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
            )
          ],
        ),
      ),
    );
  }
}
