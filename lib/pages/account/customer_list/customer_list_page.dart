import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/pages/account/customer_list/customer_list_controller.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/search_widget.dart';

class CustomerListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomerListState();
  }
}

class CustomerListState extends State<CustomerListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final CustomerListController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButtonWidget(),
        backgroundColor: AppColors.blue,
        centerTitle: false,
        title: Text("Chọn 1 khách hàng"),
        /*title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (keyword) async {
                controller.getListAllCustomer();
              },
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: Colors.white, fontSize: 14),
              controller: controller.edittextController,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.zero,
                  hintText: "Khách hàng"),
            ),
          ],
        ),*/
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
            vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
        child: Column(
          children: [
            SearchWidget(
                hintText: "Nhập mã khách hàng",
                textEditingController: controller.edittextController,
                onChange: (keyword) async {
                  controller.getListAllCustomer();
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
                  onRefresh: () => controller.getListAllCustomer(),
                  onLoading: () => controller.getListAllCustomer(isLoadMore: true),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _CustomerWidget(
                          customer: customers![index],
                          backgroundColor:
                          index % 2 == 0 ? AppColors.grey50.withOpacity(0.1) : null,
                          onPress: () {
                            Get.back(result: customers[index]);
                          },
                        );
                      },
                      itemCount: customers?.length ?? 0),
                );
              },
              onEmpty: EmptyDataWidget(
                onReloadData: () => controller.getListAllCustomer(),
              )),
            )
          ],
        )
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
            trailing: Icon(Icons.check_circle, color: AppColors.green, size: 23.sp,),
          ),
        )
    );
  }
}
