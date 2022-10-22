import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/text_theme_app.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/price_list_object.dart';
import 'package:sale_soft/model/price_list_option.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/choose_items/inventory_item_quote_price_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/price_info_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/send_price_quote/create_price_list_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/widgets/app_bar_price_list_widget.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/represent/filter_represent_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/my_combo_box_widget.dart';
import 'package:sale_soft/widgets/text_form_field_widget.dart';

class PriceListInfoPage extends StatelessWidget {
  PriceListInfoPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<PriceInfoController>();
  final controllerCart = Get.find<InventoryItemQuotePriceController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarPriceListWidget(
        title: "Thông tin báo giá",
        onBackAction: () {
          Navigator.pop(context, false);
        },
        onNextAction: () {
          controller.isSelectedCustomer.value = true;
          if (_formKey.currentState == null) return;
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            //kiểm tra từ ngày đến ngày
            DateTime _tuNgayTemp = controller.fromDate;
            DateTime _denNgayTemp = controller.toDate;
            if (_denNgayTemp.isBefore(_tuNgayTemp) ||
                _denNgayTemp.isAtSameMomentAs(_tuNgayTemp)) {
              showToast("Ban chọn sai thời gian. Đến ngày phải sau Từ ngày");
              return;
            }

            //thông tin khách hàng
            PriceListObject priceListObject = new PriceListObject();
            priceListObject.Code = controller.customerCodeEditController.text.trim();
            priceListObject.Ten = controller.customerNameEditController.text.trim();
            priceListObject.Email = controller.customerEmailEditController.text.trim();
            priceListObject.NguoiDaiDien = controller.nguoiDaiDienEditController.text.trim();
            priceListObject.DienThoai = controller.soDienThoaiEditController.text.trim();
            priceListObject.XungDanh = controller.xungDanh?.Name ?? "";
            priceListObject.TuXung = controller.tuXung ?? "";
            //thông tin báo giá
            priceListObject.DaiDienHang = controller.daiLy?.Name ?? "";
            priceListObject.PTVC = controller.phuongThucVanChuyen?.Name ?? "";
            priceListObject.PTVC_ID = controller.phuongThucVanChuyen?.Code ?? "";
            priceListObject.TGGH = controller.thoiGianCapHang?.Name ?? "";
            priceListObject.TGGH_ID = controller.thoiGianCapHang?.Code ?? "";
            priceListObject.DKTT = controller.dieuKienThanhToan?.Name ?? '';
            priceListObject.DKTT_ID = controller.dieuKienThanhToan?.Code ?? '';
            priceListObject.LoaiTien = controller.tienTe;
            priceListObject.TuNgay = controller.tuNgay;
            priceListObject.DenNgay = controller.denNgay;
            priceListObject.VAT = controller.includeVat.value;

            print("json encode");
            print(json.encode(priceListObject));
            Get.toNamed(
              ERouter.priceProductItemsPage.name,
              arguments: PriceListObjectArgument(priceListObject: priceListObject)
            );
          }
        },
      ),
      body: controller.obx((data) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Khách hàng"),
                  SizedBox(height: 8),
                  SearchCustomerWidget(),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextFormFieldWidget(
                    label: "Email",
                    textEditingController: controller.customerEmailEditController,
                    onChange: (keyword) {
                      controllerCart.customerEmail = keyword;
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextFormFieldWidget(
                    label: "Người đại diện",
                    textEditingController: controller.nguoiDaiDienEditController,
                    onChange: (keyword) {
                      controllerCart.nguoiDaiDien = keyword;
                      print("nguoi dai dien: $keyword");
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextFormFieldWidget(
                    label: "Số điện thoại",
                    isValidator: false,
                    textEditingController: controller.soDienThoaiEditController,
                    onChange: (keyword) {
                      controllerCart.customerPhone = keyword;
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Xưng danh"),
                  SizedBox(height: 8),
                  MyComboBox<PriceListOption>(
                    hint: 'Chạm để chọn',
                    items: controller.dsXungDanh,
                    bindTitle: (item) => item.Name,
                    onChanged: (PriceListOption? value) {
                      controller.xungDanh = value;
                      controllerCart.xungDanh = value;
                    },
                    value: controller.xungDanh,
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Tự xưng"),
                  SizedBox(height: 8),
                  MyComboBox(
                    value: controller.tuXung,
                    hint: 'Chạm để chọn',
                    items: controller.dsTuXung,
                    bindTitle: (item) => item.toString(),
                    onChanged: (String? value) {
                      controller.tuXung = value;
                      controllerCart.tuXung = value;
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  Container(
                    width: size.width,
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            color: AppColors.blue50,
                            height: 1,
                          ),
                        ),
                        Text(
                          "Thông tin báo giá",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 8,
                            ),
                            color: AppColors.blue50,
                            height: 1,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Đại lý"),
                  SizedBox(height: 8),
                  MyComboBox<PriceListOption>(
                    hint: 'Chạm để chọn',
                    value: controller.daiLy,
                    items: controller.dsDaiLy,
                    bindTitle: (item) => item.Name,
                    onChanged: (PriceListOption? value) {
                      controller.daiLy = value;
                      controllerCart.daiLy = value;
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Phương thức vận chuyển"),
                  SizedBox(height: 8),
                  MyComboBox<PriceListOption>(
                    hint: 'Chạm để chọn',
                    value: controller.phuongThucVanChuyen,
                    items: controller.dsPhuongThucVanChuyen,
                    bindTitle: (item) => item.Name,
                    onChanged: (PriceListOption? value) {
                      controller.phuongThucVanChuyen = value;
                      controllerCart.phuongThucVanChuyen = value;
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Thời gian giao hàng"),
                  SizedBox(height: 8),
                  MyComboBox<PriceListOption>(
                    hint: 'Chạm để chọn',
                    value: controller.thoiGianCapHang,
                    items: controller.dsThoiGianCapHang,
                    bindTitle: (item) => item.Name,
                    onChanged: (PriceListOption? value) {
                      controller.thoiGianCapHang = value;
                      controllerCart.thoiGianCapHang = value;
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Điều kiện thanh toán"),
                  SizedBox(height: 8),
                  MyComboBox<PriceListOption>(
                    hint: 'Chạm để chọn',
                    value: controller.dieuKienThanhToan,
                    items: controller.dsDieuKienThanhToan,
                    bindTitle: (item) => item.Name,
                    onChanged: (PriceListOption? value) {
                      controller.dieuKienThanhToan = value;
                      controllerCart.dieuKienThanhToan = value;
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Đơn vị tiền tệ"),
                  SizedBox(height: 8),
                  MyComboBox(
                    hint: 'Chạm để chọn',
                    value: controller.tienTe,
                    items: controller.dsTienTe,
                    bindTitle: (item) => item.toString(),
                    onChanged: (String? value) {
                      controller.tienTe = value!;
                      controllerCart.tienTe = value;
                    },
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  TextThemeApp.wdgTitle("Thời gian"),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFe7ebed),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: InkWell(
                            splashColor: Colors.red[50],
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            onTap: () async {
                              final DateTime? selectedDate = await showDatePicker(
                                context: context,
                                locale: const Locale("vi", "VN"),
                                initialDate: controller.fromDate,
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2101),
                                cancelText: 'Bỏ qua',
                                confirmText: 'Đồng ý',
                                builder: (buildContext, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: AppColors.blue,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: AppColors.blue,
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (selectedDate != null) {
                                controller.fromDate = selectedDate;
                                controllerCart.fromDate = selectedDate;
                                controller.tuNgay =  DateFormat('dd/MM/yyyy').format(selectedDate);
                                controller.update();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsets.all(8.0),
                              color: AppColors.blue50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      DateFormat('dd/MM/yyyy').format(controller.fromDate),
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFe7ebed),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: InkWell(
                            splashColor: Colors.red[50],
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            onTap: () async {
                              final DateTime? selectedDate = await showDatePicker(
                                context: context,
                                locale: const Locale("vi", "VN"),
                                initialDate: controller.toDate,
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2101),
                                cancelText: 'Bỏ qua',
                                confirmText: 'Đồng ý',
                                builder: (buildContext, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: AppColors.blue,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: AppColors.blue,
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (selectedDate != null) {
                                controller.toDate = selectedDate;
                                controllerCart.toDate = selectedDate;
                                controller.denNgay =  DateFormat('dd/MM/yyyy').format(selectedDate);
                                controller.update();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsets.all(8.0),
                              color: AppColors.blue50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      DateFormat('dd/MM/yyyy').format(controller.toDate),
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _CheckBoxButtonWidget(
                        title: 'Đã có VAT',
                        onPress: (value) {
                          controller.includeVat.value = value;
                          controllerCart.includeVat.value = value;
                        },
                        isChecked: controller.includeVat,
                      )
                    ],
                  ),
                  AppConstant.spaceVerticalSmallExtraExtraExtra,
                ],
              ),
            ),
          ),
        );
      })
    );
  }
}

class SearchCustomerWidget extends StatelessWidget {
  const SearchCustomerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerCart = Get.find<InventoryItemQuotePriceController>();
    final controller = Get.find<PriceInfoController>();
    return controller.obx((state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.blue100,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            height: 48,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      onTap: () async {
                        var result =  await Get.toNamed(
                            ERouter.customerList.name
                        );
                        if(result != null) {
                          CustomerModel customer = result;
                          controller.setCustomer(customer);

                          if(customer.code == null || customer.code == "") {
                            showErrorToast("Mã khách hàng không hợp lệ.");
                          } else {
                            showViewDialog(
                                context,
                                FilterRepresentWidget(
                                  customerCode: customer.code ?? "",
                                  onDone: (item) async {
                                    Get.back();
                                    controller.customerEmailEditController.text = item.Email ?? "";
                                    controller.nguoiDaiDienEditController.text = item.Name ?? "";
                                    controller.soDienThoaiEditController.text = item.Phone ?? "";
                                    controllerCart.customerEmail = controller.customerEmailEditController.text;
                                    controllerCart.nguoiDaiDien = controller.nguoiDaiDienEditController.text;
                                    controllerCart.customerPhone = controller.soDienThoaiEditController.text;
                                  },
                                )
                            );
                          }
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          controller.customerCodeEditController.text = "";
                          controller.update();
                          return "";
                        }
                        controller.customerCodeEditController.text = value.trim();
                        controller.update();
                        return null;
                      },
                      readOnly: true,
                      controller: controller.customerCodeEditController,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(color: AppColors.grey300, fontSize: 14, fontWeight: FontWeight.bold),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 50, right: 8, top: 2, bottom: 2),
                        hintText: "Chọn khách hàng",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 37,
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: AppColors.grey300,
                        size: 32.r,
                      ),
                    )
                  ],
                ),
                Container(
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(width: 0.8, color: AppColors.grey50))),
                  width: 37,
                  child: Icon(Icons.search, color: AppColors.grey300, size: 19.sp,),
                ),
              ],
            ),
          ),
          controller.customerCodeEditController.text.trim() == "" && controller.isSelectedCustomer.value == true ?
          Padding(
            child: Text("Thông tin bắt buộc", style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.normal, fontSize: 13.sp)),
            padding: const EdgeInsets.only(left: 15, top: 8),
          ) : SizedBox(height: 0,)
        ],
      );
    });
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
            horizontal: AppConstant.kSpaceHorizontalSmallExtra),
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
                  ?.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}