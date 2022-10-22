import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/item_in_stock_model.dart';
import 'package:sale_soft/pages/account/inventory_item_in_stock/inventory_item_in_stock_controller.dart';

class InventoryItemInStockPage extends StatefulWidget {
  InventroyItemModel inventroyItemModel;
  InventoryItemInStockPage(this.inventroyItemModel);

  @override
  State<StatefulWidget> createState() {
    return InventoryItemInStockState();
  }
}

class InventoryItemInStockState extends State<InventoryItemInStockPage>
    with AutomaticKeepAliveClientMixin<InventoryItemInStockPage> {
  final controller = Get.put(InventoryItemInStockController());
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return controller.obx((listData) {
      var originalLength = listData!.length;
      listData.insert(0, ItemInStockModel());
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tồn kho: ${widget.inventroyItemModel.code.toString()}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontSize: 12.5.sp, color: AppColors.grey, fontWeight: FontWeight.bold),
            ),
            AppConstant.spaceVerticalSmall,
            Text(
              widget.inventroyItemModel.name.toString(),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18.5.sp),
            ),
            SizedBox(
              height: 16,
            ),

            originalLength == 0 ?
            Center(
              child: Text("Sản phẩm hiện tại không tồn kho."),
            ) :
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: originalLength + 1,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return buildHeader();
                } else {
                  return Container(
                    color: index % 2 == 0 ? AppColors.grey50.withOpacity(0.3) : null,
                    child: buildItem(listData[index]),
                  );
                }
              },
            )
          ],
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller.inventroyItemModel = widget.inventroyItemModel;
  }

  Widget buildHeader() {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          verticalLine(),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  horirontalLine(),
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        height: 35,
                        color: AppColors.grey50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Stt",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        )),
                  ),
                  horirontalLine()
                ],
              )),
          Expanded(
              flex: 8,
              child: Column(
                children: [
                  horirontalLine(),
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        height: 35,
                        color: AppColors.grey50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Kho Hàng",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  horirontalLine(),
                ],
              )),
          Expanded(
              flex: 4,
              child: Column(
                children: [
                  horirontalLine(),
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        height: 35,
                        color: AppColors.grey50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Số lượng   ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        )),
                  ),
                  horirontalLine()
                ],
              )),
          verticalLine()
        ],
      ),
    );
  }

  Container verticalLine() {
    return Container(
      width: 1,
      height: 35,
      color: AppColors.grey,
    );
  }

  Container horirontalLine() {
    return Container(
      height: 1,
      color: AppColors.grey,
    );
  }

  Widget buildItem(ItemInStockModel item) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          verticalLine(),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        height: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.STT.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ],
                        )),
                  ),
                  horirontalLine()
                ],
              )),
          Expanded(
              flex: 8,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        height: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.Kho ?? "",
                              style: TextStyle(fontWeight: FontWeight.normal),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )),
                  ),
                  horirontalLine(),
                ],
              )),
          Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        height: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatQuanlity(item.Ton).toString() + "   ",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ],
                        )),
                  ),
                  horirontalLine()
                ],
              )),
          verticalLine()
        ],
      ),
    );
  }
}
