import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/pages/account/order_sale_item/order_sale_item_controller.dart';
import 'package:sale_soft/pages/account/user_admin_page/user_admin_controller.dart';
import 'package:sale_soft/pages/account/widgets/function_item_widget.dart';
import 'package:sale_soft/pages/account/widgets/user_info_widget.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/description_widget.dart';

class UserAdminPage extends StatelessWidget {
  const UserAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserAdminController());
    return controller.obx((listData) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            UserInfoWidget(
              name: controller.userName.value != null ? controller.userName.value : "",
            ),
            Expanded(
              child: SmartRefresher(
                controller: controller.refreshController,
                enablePullDown: true,
                onRefresh: () {
                  controller.fetchData(isRefreshData: true);
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      left: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                      right: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                      bottom: AppConstant.kSpaceVerticalSmallExtraExtra),
                  itemBuilder: (context, index) {
                    final UserAdminItemDisplay item = listData![index];
                    switch (item.type) {
                      case EUserAdminItemType.header:
                        return _HeaderWidget();
                      case EUserAdminItemType.title:
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppConstant
                                  .kSpaceVerticalSmallExtraExtraExtra),
                          child: Text(
                            item.title ?? '',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        );
                      case EUserAdminItemType.store:
                        return Column(
                          children: [
                            DescriptionWidget(
                              index: item.revenueStore?.stt ?? 0,
                              colorIndex: item.revenueStore?.getColor() ??
                                  AppColors.orange,
                              title: item.revenueStore?.cuaHang ?? '',
                              subTitle: item.revenueStore?.subTitle,
                              totalAmount: item.revenueStore?.soTien ?? 0.0,
                            ),
                            Divider(
                              thickness: 0.25,
                              color: AppColors.grey50,
                            ),
                          ],
                        );
                    }
                  },
                  itemCount: listData?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Tỉ lệ trên design
    final widthItem = Get.width * (70 / 360);
    return Column(
      children: [
        _FunctionFistWidget(
          widthItem: widthItem,
        ),
        AppConstant.spaceVerticalSmallMedium,
        _FunctionSecondsWidget(
          widthItem: widthItem,
        ),

        /*AppConstant.spaceHorizontalMediumExtra,
        FunctionItemWidget(
            title: 'Chi tiết trong kỳ',
            width: widthItem,
            height: widthItem,
            backgroundColor: AppColors.orange,
            imageAssetName: AppResource.icNote,
            widthIcon: widthItem * 1 / 2,
            onPress: () {
              Get.toNamed(ERouter.adChiTietThuChiPage.name);
            }),*/
      ],
    );
  }
}

class _FunctionFistWidget extends StatelessWidget {
  const _FunctionFistWidget({
    Key? key,
    required this.widthItem,
  }) : super(key: key);

  final double widthItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FunctionItemWidget(
            title: 'Tình hình kinh doanh',
            width: widthItem,
            height: widthItem,
            backgroundColor: AppColors.red,
            imageAssetName: AppResource.icIncrease,
            widthIcon: widthItem * 1 / 2,
            onPress: () {
              Get.toNamed(ERouter.businessStatusPage.name);
            },
          ),
          AppConstant.spaceHorizontalMediumExtra,
          FunctionItemWidget(
              title: 'Quản lý quỹ',
              width: widthItem,
              height: widthItem,
              backgroundColor: AppColors.green,
              imageAssetName: AppResource.icProfit,
              widthIcon: widthItem * 1 / 2,
              onPress: () {
                Get.toNamed(ERouter.monthlyReportPage.name);
              }),
          AppConstant.spaceHorizontalMediumExtra,
          FunctionItemWidget(
              title: 'Phiếu đặt hàng',
              width: widthItem,
              height: widthItem,
              backgroundColor: AppColors.orange,
              imageAssetName: AppResource.icNote,
              widthIcon: widthItem * 1 / 2,
              onPress: () {
                //Get.toNamed(ERouter.orderPage.name);
                Get.toNamed(
                    ERouter.orderSalePage.name,
                    arguments: OrderListArgument(
                      title: "Danh sách phiếu đặt hàng",
                      type: AppConstant.otPhieuDatHang,
                    )
                );
              }),
        ],
      ),
    );
  }
}

class _FunctionSecondsWidget extends StatelessWidget {
  const _FunctionSecondsWidget({
    Key? key,
    required this.widthItem,
  }) : super(key: key);

  final double widthItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FunctionItemWidget(
            title: 'Tra cứu khách hàng',
            width: widthItem,
            height: widthItem,
            backgroundColor: AppColors.blue,
            imageAssetName: AppResource.icDocument,
            widthIcon: widthItem * 1 / 2,
            onPress: () {
              Get.toNamed(ERouter.customerPage.name);
            },
          ),
          AppConstant.spaceHorizontalMediumExtra,
          FunctionItemWidget(
              title: 'Tra cứu công nợ khách hàng',
              width: widthItem,
              height: widthItem,
              onPress: () {
                Get.toNamed(ERouter.debt.name);
              },
              backgroundColor: AppColors.turquoise,
              imageAssetName: AppResource.icTrade,
              widthIcon: widthItem * 1 / 2),
          AppConstant.spaceHorizontalMediumExtra,
          FunctionItemWidget(
            title: 'Tra cứu hàng hóa',
            width: widthItem,
            height: widthItem,
            backgroundColor: AppColors.yellow,
            imageAssetName: AppResource.icBox,
            widthIcon: widthItem * 1 / 2,
            onPress: () {
              Get.toNamed(ERouter.inventoryItem.name);
            },
          ),
        ],
      ),
    );
  }
}
