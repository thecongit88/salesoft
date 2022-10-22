import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/pages/account/search_customer/customer_controller.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/search_widget.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

///
/// Màn hình tra cứu khách hàng
///
class CustomersPage extends StatelessWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///Khởi tạo controller cho getx
    final CustomersController controller = Get.find();
    final title = controller.argument?.title ?? "Tra cứu khách hàng";
    //final int totalAmount = controller.argument?.totalAmount?.toInt() ?? 0;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButtonWidget(),
          backgroundColor: AppColors.blue,
          centerTitle: false,
          title: TitleAppBarWidget(
            title: "$title",
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
              vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
          child: Column(
            children: [
              /*totalAmount > 0 ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Có tất cả ${controller.argument!.totalAmount!.toInt()} khách hàng",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  SizedBox(
                    child: Divider(
                      thickness: 0.25,
                      color: AppColors.grey50,
                    ),
                    width: 150,
                  ),
                ],
              ) : SizedBox(height: 0,),
              AppConstant.spaceVerticalSmallMedium,*/
              ///Hai check box để filter khách hàng và nhà cung cấp, 2 check box này có thể thay đổi màu được
              _FilterWidget(),
              AppConstant.spaceVerticalSmallMedium,
              SearchWidget(
                  hintText: "Nhập mã khách hàng",
                  textEditingController: controller.textEditController,
                  onChange: (keyword) async {
                    controller.fetchCustomers();
                  },
                  boderRightPrefixIcon: false,
              ),
              AppConstant.spaceVerticalSmallMedium,
              Expanded(
                child: controller.obx((customers) {
                  return SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () => controller.fetchCustomers(),
                    onLoading: () =>
                        controller.fetchCustomers(isLoadMore: true),
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return _CustomerWidget(
                            customer: customers![index],
                            backgroundColor: index % 2 == 0
                                ? AppColors.grey50.withOpacity(0.1)
                                : null,
                            onPress: () {
                              Get.toNamed(ERouter.customerDetailPage.name,
                                  arguments: customers[index]);
                            },
                          );
                        },
                        itemCount: customers?.length ?? 0),
                  );
                },
                    onEmpty: EmptyDataWidget(
                      onReloadData: () => controller.fetchCustomers(),
                    )),
              )
            ],
          ),
        ));
  }
}

class _CustomerWidget extends StatelessWidget {
  const _CustomerWidget({
    Key? key,
    this.onPress,
    this.customer,
    this.backgroundColor,
  }) : super(key: key);

  final Function()? onPress;
  final CustomerModel? customer;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onPress,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 0.8, color: AppColors.grey50))),
            child: Card(
              elevation: 2,  // Change this
              shadowColor: AppColors.grey50,  // Change this
              child: Container(
                  width: 50,
                  foregroundDecoration: const RotatedCornerDecoration(
                    color: Color(0xFF0873AC),
                    geometry: const BadgeGeometry(width: 36, height: 36, alignment: BadgeAlignment.topLeft),
                    textSpan: TextSpan(text: 'Cấp', style: TextStyle(fontSize: 10)),
                    labelInsets: LabelInsets(baselineShift: 2, start: 1),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("${customer?.level ?? "-"}", style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontSize: 15.sp, height: 1.2, color: AppColors.grey450, fontWeight: FontWeight.bold),),
                    ),
                  )
              ),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer?.code ?? '',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
              ),

              AppConstant.spaceVerticalSmall,
              Text(
                customer?.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontSize: 14.sp, height: 1.2, color: AppColors.grey),
              ),
              AppConstant.spaceVerticalSmall,
            ],
          ),
          subtitle: Text("Nhân viên: ${customer?.staff ?? ''}"),
          trailing: Icon(Icons.arrow_right, color: AppColors.grey50,),
        ),
      )
    );
  }
}

class _FilterWidget extends StatelessWidget {
  const _FilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomersController controller = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CheckBoxButtonWidget(
          title: 'Khách hàng',
          onPress: (value) {
            controller.fetchCustomers();
          },
          isChecked: controller.isSelectedCustomer,
        ),
        _CheckBoxButtonWidget(
          title: 'Nhà cung cấp',
          onPress: (value) {
            controller.fetchCustomers();
          },
          isChecked: controller.isSelectedSupply,
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

class TitleAppBarWidget extends StatelessWidget {
  const TitleAppBarWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6?.copyWith(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_outlined,
        color: Colors.white,
      ),
      onPressed: () {
        Get.back();
      },
    );
  }
}