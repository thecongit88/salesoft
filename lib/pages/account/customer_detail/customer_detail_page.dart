import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/invoice_model.dart';
import 'package:sale_soft/model/topsale_model.dart';
import 'package:sale_soft/pages/account/customer_detail/customer_detail_controller.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_controller.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_page.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/expanded_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// Chi tiết khách hàng
///
class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller = Get.find();
    final CustomerModel argument = Get.arguments;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButtonWidget(),
          backgroundColor: AppColors.blue,
          centerTitle: false,
          title: TitleAppBarWidget(
            title: argument.name ?? '',
          ),
        ),
        body: controller.obx((data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
              child: Column(
                children: [
                  _CustomerInfoWidget(),
                  _ContactInfoWidget(),
                  _InvoiceWidget(),
                  _TopSaleWidget()
                ],
              ),
            ),
          );
        }));
  }
}

class _TopSaleWidget extends StatelessWidget {
  const _TopSaleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller = Get.find();
    if (controller.topSales.value.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          top: AppConstant.kSpaceVerticalSmallExtraExtra,
        ),
        child: _ExpandedItem(
          defaultExpanded: false,
          title: 'Top 5 chứng từ',
          childExpanded: ListView.separated(
              padding:
                  EdgeInsets.only(top: AppConstant.kSpaceVerticalSmallExtra),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final TopsaleModel invoice = controller.topSales[index];
                return InkWellWidget(
                  onPress: () {
                    Dialog dialog = Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.r)), //this right here
                      child: ReceiptDetailPage(invoice.chungTu!),
                      insetPadding: EdgeInsets.symmetric(
                          horizontal:
                              AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
                    );
                    showDialog(context: context, builder: (context) => dialog)
                        .then((value) {
                      Get.delete<ReceiptDetailController>();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              width: 22.r,
                              height: 22.r,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: invoice.getColor(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.r)),
                                  shape: BoxShape.rectangle),
                              child: Text(
                                invoice.stt.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            AppConstant.spaceHorizontalSmallExtra,
                            Expanded(
                              child: _TopSaleColumnWidget(
                                topValue: invoice.loai ?? '',
                                botValue: invoice.chungTu ?? '',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: _TopSaleColumnWidget(
                          topValue:
                              'Ngày: ${DateTimeHelper.dateToStringFormat(date: invoice.ngay)}',
                          botValue:
                              'Số lượng: ${(invoice.soLuong ?? 0).toInt().toString()}',
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          (invoice.thanhTien ?? 0).toAmountFormat(),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 1,
                  color: AppColors.grey50,
                );
              },
              itemCount: controller.topSales.length),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _TopSaleColumnWidget extends StatelessWidget {
  const _TopSaleColumnWidget({
    Key? key,
    required this.topValue,
    required this.botValue,
  }) : super(key: key);

  final String topValue;
  final String botValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topValue,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          botValue,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.grey300),
        ),
      ],
    );
  }
}

class _InvoiceWidget extends StatelessWidget {
  const _InvoiceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller = Get.find();
    if (controller.invoices.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          top: AppConstant.kSpaceVerticalSmallExtraExtra,
        ),
        child: _ExpandedItem(
          defaultExpanded: false,
          title: 'Top 5 giao dịch',
          childExpanded: ListView.separated(
              padding:
                  EdgeInsets.only(top: AppConstant.kSpaceVerticalSmallExtra),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final InvoiceModel invoice = controller.invoices[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _OneLineWidget(
                              title: "Ngày: ",
                              value: DateTimeHelper.dateToStringFormat(
                                      date: invoice.ngay) ??
                                  ''),
                        ),
                        Expanded(
                          child: _OneLineWidget(
                              title: "NV: ", value: invoice.nhanVien ?? ''),
                        )
                      ],
                    ),
                    AppConstant.spaceVerticalSmall,
                    Text(
                      "Nội dung ${invoice.noiDung ?? ''}",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(color: AppColors.grey),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 1,
                  color: AppColors.grey50,
                );
              },
              itemCount: controller.invoices.length),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _ContactInfoWidget extends StatelessWidget {
  const _ContactInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller = Get.find();
    if (controller.customers.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          top: AppConstant.kSpaceVerticalSmallExtraExtra,
        ),
        child: _ExpandedItem(
          defaultExpanded: false,
          title: 'Thông tin liên hệ',
          childExpanded: ListView.separated(
              padding:
                  EdgeInsets.only(top: AppConstant.kSpaceVerticalSmallExtra),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final CustomerDetailModel item = controller.customers[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWellWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OneLineWidget(
                              title: "Mr ",
                              value: item.nguoiLienHe ?? '',
                            ),
                            AppConstant.spaceVerticalSmall,
                            Row(
                              children: [
                                Image.asset(
                                  AppResource.phone,
                                  width: 10.r,
                                  height: 10.r,
                                ),
                                AppConstant.spaceHorizontalSmall,
                                Expanded(
                                  child: Text(
                                    item.dienThoai ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blue),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        onPress: () {
                          launch("tel:${item.dienThoai}");
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWellWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OneLineWidget(
                              title: "Vị trí: ",
                              value: item.chucVu ?? '',
                            ),
                            AppConstant.spaceVerticalSmall,
                            Row(
                              children: [
                                Image.asset(
                                  AppResource.icEmail,
                                  width: 10.r,
                                  height: 10.r,
                                ),
                                AppConstant.spaceHorizontalSmallExtra,
                                Expanded(
                                  child: Text(
                                    item.email ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blue),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        onPress: () {
                          launch("mailto:${item.email}");
                        },
                      )
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 1,
                  color: AppColors.grey50,
                );
              },
              itemCount: controller.customers.length),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _CustomerInfoWidget extends StatelessWidget {
  const _CustomerInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller = Get.find();
    if (controller.customers.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          top: AppConstant.kSpaceVerticalSmallExtraExtra,
        ),
        child: _ExpandedItem(
          defaultExpanded: true,
          title: 'Thông tin khách hàng',
          titleColor: AppColors.blue,
          childExpanded: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: _OneLineWidget(
                      title: "Mã giao dịch: ",
                      value: controller.customers.first.code ?? "",
                    ),
                  ),
                  Expanded(
                    child: _OneLineWidget(
                      title: "MST: ",
                      value: controller.customers.first.taxCode ?? "",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              _OneLineWidget(
                title: "NV chăm sóc: ",
                value: controller.customers.first.staff ?? "",
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                controller.customers.first.address ?? '',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: AppColors.grey),
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _OneLineWidget extends StatelessWidget {
  const _OneLineWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
          text: title,
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(color: AppColors.grey),
          children: [
            TextSpan(
                text: value,
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ))
          ]),
    );
  }
}

class _ExpandedItem extends StatelessWidget {
  const _ExpandedItem({
    Key? key,
    required this.childExpanded,
    required this.title,
    required this.defaultExpanded,
    this.titleColor,
  }) : super(key: key);

  final Widget childExpanded;
  final String title;
  final Color? titleColor;
  final bool? defaultExpanded;

  @override
  Widget build(BuildContext context) {
    var isExpanded = defaultExpanded.obs;

    return Obx(() {
      return Container(
        padding: EdgeInsets.only(
            left: AppConstant.kSpaceHorizontalSmallExtraExtra,
            right: AppConstant.kSpaceHorizontalSmallExtraExtra,
            top: AppConstant.kSpaceVerticalSmallExtraExtra,
            bottom: AppConstant.kSpaceVerticalSmallExtraExtra),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: AppColors.grey50,
            ),
            shape: BoxShape.rectangle),
        child: Column(
          children: [
            _TitleView(
              title: title,
              isExpanded: isExpanded.value ?? false,
              titleColor: titleColor,
              onChangeValue: () {
                isExpanded.value = !(isExpanded.value ?? false);
              },
            ),
            ExpandedWidget(
              expand: isExpanded.value ?? false,
              child: childExpanded,
            )
          ],
        ),
      );
    });
  }
}

class _TitleView extends StatelessWidget {
  const _TitleView({
    Key? key,
    required this.title,
    required this.isExpanded,
    this.titleColor,
    this.onChangeValue,
  }) : super(key: key);

  final String title;
  final bool isExpanded;
  final Color? titleColor;
  final Function()? onChangeValue;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onChangeValue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: titleColor ?? AppColors.grey,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.grey300,
          )
        ],
      ),
    );
  }
}
