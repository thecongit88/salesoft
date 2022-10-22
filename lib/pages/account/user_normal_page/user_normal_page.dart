import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:mailer/mailer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/pages/account/order_sale_item/order_sale_item_controller.dart';
import 'package:sale_soft/pages/account/search_customer/customer_controller.dart';
import 'package:sale_soft/pages/account/user_normal_page/user_normal_controller.dart';
import 'package:sale_soft/pages/account/widgets/barchart_widget.dart';
import 'package:sale_soft/pages/account/widgets/function_item_widget.dart';
import 'package:sale_soft/pages/account/widgets/user_info_widget.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/description_widget.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:mailer/smtp_server.dart';

///
/// Màn hình người dùng Bình thường
///
class UserNormalPage extends StatelessWidget {
  const UserNormalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Tính toán chiều rộng của 1 item theo kích thước màn hình
    final widthItem = (Get.width - (28 * 3) - 32) / 4;
    final controller = Get.put(UserNormalController());
    return controller.obx(
      (data) {
        return SmartRefresher(
            enablePullDown: true,
            onRefresh: () {
              controller.fetchData(isRefreshData: true);
            },
            controller: controller.refreshController,
            child: _ContentWidget(widthItem: widthItem));
      },
      onEmpty: EmptyDataWidget(
        onReloadData: () => controller.fetchData(),
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget({
    Key? key,
    required this.widthItem,
  }) : super(key: key);

  final double widthItem;

  @override
  Widget build(BuildContext context) {
    final UserNormalController controller = Get.find();
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Column(
            children: [
              Obx(() {
                return UserInfoWidget(name: controller.userName.value);
              }),

              _FunctionWidget(widthItem: widthItem),
              BarChartWidget(
                listData: controller.getDataChart(),
              ),
              _DescriptionLabelChartWidget(
                totalThisMonnth: controller.staffRevenue?.ThangNay ?? 0.0,
                totalLastMonth: controller.staffRevenue?.ThangTruoc ?? 0.0,
              ),

              AppConstant.spaceVerticalSmallExtra,
              ///Commented hình ảnh biểu đồ doanh thu theo nhóm
              //buildGroupRevenueWidget(),
              AppConstant.spaceVerticalSmallExtra,
              _DescriptionWidget(),
              SizedBox(
                height: AppConstant.kSpaceVerticalLarge,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildGroupRevenueWidget() {
    final UserNormalController controller = Get.find();

    return Container(
      margin: EdgeInsets.all(AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      padding: EdgeInsets.only(
          left: AppConstant.kSpaceHorizontalSmall,
          right: AppConstant.kSpaceHorizontalSmall,
          top: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
          bottom: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: AppColors.greyBackground,
          border: Border.all(width: 0.5, color: AppColors.grey50)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Doanh số theo nhóm",
                        style: TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: AppConstant.kSpaceHorizontalSmallExtra,
                      ),
                      Text(
                          (controller.staffRevenue?.DoanhSoNhom ?? 0)
                                  .toAmountFormat() +
                              "đ",
                          style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 20))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 0.1.sw),
                child: Image.asset(
                  AppResource.icGroupRevenue,
                  width: 0.15.sw,
                  height: 0.15.sw,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    controller.staffRevenue?.SoPhieu?.toString() ?? "",
                    style: TextStyle(color: AppColors.orange),
                  ),
                  AppConstant.spaceVerticalSmall,
                  Text(
                    "Số phiếu trong tháng",
                    style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10.sp),
                    textAlign: TextAlign.center,
                  )
                ],
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                height: 40.h,
                width: 0.5,
                color: AppColors.grey60,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    controller.staffRevenue?.SoBaoGia?.toString() ?? "",
                    style: TextStyle(color: AppColors.orange),
                    textAlign: TextAlign.center,
                  ),
                  AppConstant.spaceVerticalSmall,
                  Text(
                    "Số báo giá trong tháng",
                    style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10.sp),
                    textAlign: TextAlign.center,
                  )
                ],
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                height: 40.h,
                width: 0.5,
                color: AppColors.grey60,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    controller.staffRevenue?.ChuaXuLy?.toString() ?? "",
                    style: TextStyle(color: AppColors.orange),
                  ),
                  AppConstant.spaceVerticalSmall,
                  Text(
                    "Yêu cầu chờ xử lý",
                    style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10.sp),
                    textAlign: TextAlign.center,
                  )
                ],
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                height: 40.h,
                width: 0.5,
                color: AppColors.grey60,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    controller.staffRevenue?.ChuaXacNhan?.toString() ?? "",
                    style: TextStyle(color: AppColors.orange),
                  ),
                  AppConstant.spaceVerticalSmall,
                  Text(
                    "Yêu cầu chờ xác nhận",
                    style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10.sp),
                    textAlign: TextAlign.center,
                  )
                ],
              )),
            ],
          )
        ],
      ),
    );
  }
}

class _DescriptionLabelChartWidget extends StatelessWidget {
  const _DescriptionLabelChartWidget({
    Key? key,
    required this.totalThisMonnth,
    required this.totalLastMonth,
  }) : super(key: key);

  final double totalThisMonnth;
  final double totalLastMonth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: AppConstant.kSpaceHorizontalMediumExtra + 54.w,
          right: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              totalThisMonnth.toAmountFormat(),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: AppColors.grey),
            ),
          ),
          AppConstant.spaceHorizontalSmallExtra,
          SizedBox(
            width: 80.w,
            child: Text(
              totalLastMonth.toAmountFormat(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: AppColors.grey),
            ),
          )
        ],
      ),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserNormalController controller = Get.find();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chăm sóc khách hàng",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 16,
          ),

          InkWellWidget(
            child: DescriptionWidget(
              index: 1,
              icon: AppResource.icDangTheoDoi,
              colorIndex: AppColors.orange,
              title: 'Đang theo dõi',
              totalAmount: controller.staffRevenue?.TheoDoi?.toDouble() ?? 0.0,
              hasSuffix: true,
            ),
            onPress: () {
              Get.toNamed(
                  ERouter.customerPage.name,
                  arguments: CustomerListArgument(
                      title: 'Đang theo dõi',
                      type: AppConstant.customerTypeAll,
                      totalAmount: controller.staffRevenue?.TheoDoi?.toDouble()
                  )
              );
            },
          ),
          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),
          InkWellWidget(
            child: DescriptionWidget(
              icon: AppResource.icPhatSinh,
              index: 2,
              colorIndex: AppColors.blue,
              title: 'Phát sinh doanh thu',
              totalAmount: controller.staffRevenue?.PhatSinh?.toDouble() ?? 0.0,
              hasSuffix: true,
            ),
            onPress: () {
              Get.toNamed(
                ERouter.customerPage.name,
                arguments: CustomerListArgument(
                    title: 'Phát sinh doanh thu',
                    type: AppConstant.customerTypePhatSinhDoanhThu,
                    totalAmount: controller.staffRevenue?.PhatSinh?.toDouble()
                )
              );
            },
          ),

          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),

          InkWellWidget(
            child: DescriptionWidget(
              icon: AppResource.icPhatSinh3T,
              index: 3,
              colorIndex: AppColors.turquoise,
              title: 'Phát sinh doanh thu / 3 tháng',
              totalAmount: controller.staffRevenue?.PhatSinh3T?.toDouble() ?? 0.0,
              hasSuffix: true,
            ),
            onPress: () {
              Get.toNamed(
                  ERouter.customerPage.name,
                  arguments: CustomerListArgument(
                      title: 'Phát sinh doanh thu / 3 tháng',
                      type: AppConstant.customerTypePhatSinhDoanhThuTrong3T,
                      totalAmount: controller.staffRevenue?.PhatSinh3T?.toDouble()
                  )
              );
            },
          ),
          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),

          InkWellWidget(
            child: DescriptionWidget(
              icon: AppResource.icKoPhatSinh3T,
              index: 4,
              colorIndex: AppColors.yellow,
              title: 'Không giao dịch quá 3 tháng',
              totalAmount:
              controller.staffRevenue?.KoPhatSinh3T?.toDouble() ?? 0.0,
              hasSuffix: true,
            ),
            onPress: () {
              Get.toNamed(
                  ERouter.customerPage.name,
                  arguments: CustomerListArgument(
                    title: 'Không giao dịch quá 3 tháng',
                    type: AppConstant.customerTypePhatSinhDoanhThuQua3T,
                    totalAmount: controller.staffRevenue?.KoPhatSinh3T?.toDouble()
                  )
              );
            },
          ),
          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),

          ///Bổ sung thêm
          InkWellWidget(
            child: DescriptionWidget(
              index: 5,
              icon: AppResource.icDept,
              colorIndex: AppColors.yellow,
              title: 'Công nợ',
              totalAmount: -1,
              hasSuffix: true,
            ),
            onPress: () {
              Get.toNamed(ERouter.debt.name);
            },
          ),

          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),

          InkWellWidget(
            child: DescriptionWidget(
              index: 6,
              icon: AppResource.icExpensive,
              colorIndex: AppColors.yellow,
              title: 'Báo giá',
              totalAmount: -1,
              hasSuffix: true,
            ),
            onPress: () {
              Get.toNamed(ERouter.inventoryItemQuotePrice.name);
            },
          ),

          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),
          ///Bổ sung thêm

          SizedBox(
            height: 8,
          ),
          Text(
            "Công nợ khách hàng",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 16,
          ),
          DescriptionWidget(
            icon: AppResource.icSoKhachNo,
            index: 4,
            colorIndex: AppColors.yellow,
            title: 'Số khách hàng nợ',
            totalAmount: controller.staffRevenue?.SoKhachNo?.toDouble() ?? 0.0,
          ),
          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),
          DescriptionWidget(
            icon: AppResource.icTienNo,
            index: 4,
            colorIndex: AppColors.yellow,
            title: 'Tổng tiền nợ',
            totalAmount: controller.staffRevenue?.TienNo?.toDouble() ?? 0.0,
          ),
          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),
          DescriptionWidget(
            index: 4,
            icon: AppResource.icTienQuaHan,
            colorIndex: AppColors.yellow,
            title: 'Tổng nợ quá hạn',
            totalAmount: controller.staffRevenue?.TienQuaHan?.toDouble() ?? 0.0,
          ),
          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
            height: 33,
          ),
        ],
      ),
    );
  }
}

class _FunctionWidget extends StatelessWidget {
  const _FunctionWidget({
    Key? key,
    required this.widthItem,
  }) : super(key: key);

  final double widthItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FunctionItemWidget(
                  title: 'Phiếu đặt hàng',
                  width: widthItem,
                  height: widthItem,
                  backgroundColor: AppColors.orange,
                  imageAssetName: AppResource.icNote,
                  onPress: () {
                    ///thêm mới phiếu đặt hàng
                    //Get.toNamed(ERouter.orderPage.name);
                    Get.toNamed(
                        ERouter.orderSalePage.name,
                        arguments: OrderListArgument(
                            title: "Danh sách phiếu đặt hàng",
                            type: AppConstant.otPhieuDatHang,
                        )
                    );
                  }),
              FunctionItemWidget(
                title: 'Khách hàng',
                width: widthItem,
                height: widthItem,
                backgroundColor: AppColors.blue,
                imageAssetName: AppResource.icDocument,
                onPress: () {
                  Get.toNamed(ERouter.customerPage.name);
                },
              ),
              FunctionItemWidget(
                title: 'Công nợ',
                width: widthItem,
                height: widthItem,
                backgroundColor: AppColors.turquoise,
                imageAssetName: AppResource.icTrade,
                onPress: () {
                  Get.toNamed(ERouter.debt.name);
                },
              ),
              FunctionItemWidget(
                  title: 'Hàng hóa',
                  width: widthItem,
                  height: widthItem,
                  backgroundColor: AppColors.yellow,
                  imageAssetName: AppResource.icBox,
                  onPress: () {
                    Get.toNamed(ERouter.inventoryItem.name);
                  }
              )
            ],
          ),
          AppConstant.spaceVerticalSmallExtraExtraExtra,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NotifyWidget(
                child: FunctionItemWidget(
                    title: 'Hóa đơn b.hàng',
                    width: widthItem,
                    height: widthItem,
                    backgroundColor: AppColors.grey400,
                    imageAssetName: AppResource.icBox,
                    iconData: Icons.article_outlined,
                    onPress: () {
                      Get.toNamed(
                          ERouter.orderSalePage.name,
                          arguments: OrderListArgument(
                            title: "Danh sách hóa đơn bán hàng",
                            type: AppConstant.otHoaDonBanHang,
                          )
                      );
                    }
                ),
                notify: 0,
              ),

              _NotifyWidget(
                child: FunctionItemWidget(
                    title: 'Báo giá',
                    width: widthItem,
                    height: widthItem,
                    backgroundColor: AppColors.greenQuotePrice,
                    imageAssetName: AppResource.icBox,
                    iconData: Icons.monetization_on_outlined,
                    onPress: () {
                      Get.toNamed(ERouter.inventoryItemQuotePrice.name);
                    }
                ),
                notify: 0,
              ),

              _NotifyWidget(
                child: FunctionItemWidget(
                    title: 'Công việc',
                    width: widthItem,
                    height: widthItem,
                    backgroundColor: AppColors.job.withOpacity(0.1),
                    imageAssetName: AppResource.icBox,
                    iconData: Icons.work_outline,
                    onPress: () {
                      showToast("Chức năng đang phát triển");
                    }
                ),
                notify: 0,
              ),

              _NotifyWidget(
                child: FunctionItemWidget(
                    title: 'Khác',
                    width: widthItem,
                    height: widthItem,
                    backgroundColor: AppColors.grey50.withOpacity(0.15),
                    imageAssetName: AppResource.icBox,
                    iconData: Icons.apps,
                    onPress: () async {
                      showToast("Chức năng đang phát triển");
                      /*final username = '';
                      final password = 'gokgzvdkgynyhjnz';
                      final smtpServer = SmtpServer(
                        'smtp.gmail.com',
                        port: 587,
                        username: username,
                        password: password,
                      );

                      final message = Message()
                        ..from = Address(username, 'Van Thanh Soft')
                        ..recipients.add('thecongit88@gmail.com')
                        ..subject = 'New POST message from user'
                        ..text = "Xin chào Công";

                      int statusCode;
                      try {
                        final sendReport = await send(message, smtpServer);
                        print(sendReport.toString());
                        statusCode = HttpStatus.ok;
                      } on MailerException catch (e) {
                        print('Message not sent: ${e.problems}');
                        statusCode = HttpStatus.internalServerError;
                        print('Message not sent: ${statusCode}');
                      }*/
                    }
                ),
                notify: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotifyWidget extends StatelessWidget {
  const _NotifyWidget({
    Key? key,
    this.notify = 9,
    required this.child
  }) : super(key: key);

  final int? notify;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: child,
        ),
        notify! > 0 ?
        Positioned(
          right: 0,
          top: 0,
          child: new Container(
            width: 33,
            height: 33,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle
            ),
            child: Center(
              child: Text(
                "${notify ?? 0}",
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        )
            : SizedBox(height: 0,)
      ],
    );
  }
}
