import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/inventory_item_category_model.dart';
import 'package:sale_soft/model/inventory_item_detail_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/invoice_model.dart';
import 'package:sale_soft/model/topsale_model.dart';
import 'package:sale_soft/pages/account/customer_detail/customer_detail_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_detail/inventory_item_detail_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_in_stock/inventory_item_in_stock_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_in_stock/inventory_item_in_stock_page.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_controller.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_page.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/expanded_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

///
/// Chi tiết khách hàng
///
class InventoryItemDetailPage extends StatelessWidget {
  const InventoryItemDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InventoryItemDetailController controller = Get.find();
    final InventroyItemModel product = controller.argument!;
    final String titleName = product.name ?? 'Quét mã: ${product.code}';
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButtonWidget(),
          backgroundColor: AppColors.blue,
          centerTitle: false,
          title: TitleAppBarWidget(
            title: '$titleName',
          ),
        ),
        body: controller.obx((contentDisplay) {
          return SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: () => controller.fetchInventoryItemDetail(),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
                child: Column(
                  children: [
                    _ProductInfoWidget(productDetail: contentDisplay),
                    SizedBox(height: 15,),
                    _ContentExtraWidget(stt: "M", title: "Mô tả", content: contentDisplay!.sumary),
                    Divider(
                      thickness: 1,
                      color: AppColors.grey50,
                    ),
                    _ContentExtraWidget(stt: "T", title: "Thông số kỹ thuật", content: contentDisplay.techParameter),
                    Divider(
                      thickness: 1,
                      color: AppColors.grey50,
                    ),
                    _ListItemExtraWidget(type: AppConstant.websiteType, title: "Link website", productDetail: contentDisplay),
                    Divider(
                      thickness: 1,
                      color: AppColors.grey50,
                    ),
                    _ListItemExtraWidget(type: AppConstant.documentType, title: "Tài liệu", productDetail: contentDisplay),
                    Divider(
                      thickness: 1,
                      color: AppColors.grey50,
                    ),

                    _ListItemExtraWidget(type: AppConstant.videoType, title: "Video", productDetail: contentDisplay),
                    Divider(
                      thickness: 1,
                      color: AppColors.grey50,
                    ),
                    _ListItemExtraWidget(type: AppConstant.imageType, title: "Hình ảnh thực tế", productDetail: contentDisplay),
                  ],
                ),
              ),
            )
          );
        },
            onEmpty: EmptyDataWidget(
              onReloadData: () => controller.fetchInventoryItemDetail(),
            ))
    );
  }
}

class _ProductInfoWidget extends StatelessWidget {
  final InventoryItemDetailModel? productDetail;
  const _ProductInfoWidget({
    Key? key,
    required this.productDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = Base64Decoder().convert(productDetail!.image.toString());
    double quantity = productDetail!.quantity!;
    return Padding(
      padding: EdgeInsets.only(
        top: AppConstant.kSpaceVerticalSmallExtraExtra,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: productDetail!.image.toString().trim() == "" ? Container(
              height: 100.h,
              child: Icon(Icons.image_outlined, color: AppColors.grey300, size: 40,),
            ) :
            Container(
              height: 100.h,
              margin: const EdgeInsets.only(right: 15),
              child: Image.memory(
                bytes,
                fit: BoxFit.fitWidth,
              ),
            ),
            flex: 3,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text('${productDetail!.name}',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                ),
                SizedBox(
                  height: 8,
                ),

                wdgCopyText(
                  _OneLineWidget(
                    title: "Mã sản phẩm: ",
                    value: '${productDetail!.code}',
                  ),
                  productDetail!.code ?? '',
                ),

                SizedBox(
                  height: 8,
                ),
                _OneLineWidget(
                  title: "Giá bán: ",
                  value: '${(productDetail!.price ?? 0).toAmountFormat()} đ',
                  color: AppColors.red,
                ),

                SizedBox(
                  height: 8,
                ),
                InkWellWidget(
                  child: Container(
                    height: 27.h,
                    width: 115.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        shape: BoxShape.rectangle),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 14.sp,),
                        SizedBox(width: 5,),
                        Text(
                          "Xem tồn kho",
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                      ],
                    )
                  ),
                  onPress: () async {
                      var item = new InventroyItemModel(code: productDetail!.code, name: productDetail!.name);
                      Dialog dialog = Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.r)), //this right here
                        child: InventoryItemInStockPage(item),
                        insetPadding: EdgeInsets.symmetric(
                            horizontal: AppConstant
                                .kSpaceHorizontalSmallExtraExtraExtra),
                      );
                      showDialog(
                          context: context,
                          builder: (context) => dialog).then((value) {
                        Get.delete<InventoryItemInStockController>();
                      });
                  },
                )
              ],
            ),
            flex: 7
          )
        ],
      )
    );
  }
}

class _ContentExtraWidget extends StatelessWidget {
  final String stt;
  final String title;
  final String? content;
  const _ContentExtraWidget({
    Key? key,
    required this.stt,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.all(0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 22.r,
            height: 22.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.all(
                    Radius.circular(4.r)),
                shape: BoxShape.rectangle),
            child: Text(
              '${this.stt}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.white),
            ),
          ),
          title: Text('${this.title}'),
          children: <Widget>[
            this.title == "Thông số kỹ thuật" ? HtmlWidget(content ?? '', textStyle: TextStyle(fontWeight: FontWeight.normal))
                :
            Text(content ?? '', style: TextStyle(fontWeight: FontWeight.normal)),
            SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }
}

class _OneLineWidget extends StatelessWidget {
  const _OneLineWidget({
    Key? key,
    required this.title,
    required this.value,
    this.color,
  }) : super(key: key);

  final String title;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
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
                      color: color ?? AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ))
          ]),
    );
  }
}

class _ListItemExtraWidget extends StatelessWidget {
  final String type;
  final String title;
  final InventoryItemDetailModel? productDetail;
  const _ListItemExtraWidget({
    Key? key,
    required this.type,
    required this.title,
    required this.productDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InventoryItemDetailController controller = Get.find();
    final int n = getLenDataType(this.type);
    return ListTileTheme(
      contentPadding: EdgeInsets.all(0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          //onExpansionChanged: (value) {
            //controller.isExpanded.value = value;
            //controller.update();
          //},
          leading: Container(
            width: 22.r,
            height: 22.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.all(
                    Radius.circular(4.r)),
                shape: BoxShape.rectangle),
            child: Text(
              '$n',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.white),
            ),
          ),
          title: Text('${this.title}'),
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: n,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var item; String name = "Link ${index+1}";
                if(this.type == AppConstant.websiteType) {
                  item = productDetail!.listWebsite![index];
                } else if(this.type == AppConstant.documentType) {
                  item = productDetail!.listDocument![index];
                  name = item.name;
                } else if(this.type == AppConstant.imageType) {
                  item = productDetail!.listImage![index];
                } else if(this.type == AppConstant.videoType) {
                  item = productDetail!.listVideo![index];
                }
                return InkWellWidget(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppConstant.kSpaceHorizontalMedium,
                      right: AppConstant.kSpaceHorizontalMedium,
                    ),
                    child: ListTile(
                      title: Text("${name.trim()}"),
                      trailing: Icon(Icons.open_in_new),
                    ),
                  ),
                  onPress: () async {
                    await openUrl(item.linkUrl);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  int getLenDataType(String type) {
    switch (type) {
      case AppConstant.websiteType:
        return productDetail!.listWebsite != null ? productDetail!.listWebsite!.length : 0 ;
      case AppConstant.videoType:
        return productDetail!.listVideo != null ? productDetail!.listVideo!.length : 0;
      case AppConstant.documentType:
        return productDetail!.listDocument != null ? productDetail!.listDocument!.length : 0;
      case AppConstant.imageType:
        return productDetail!.listImage != null ? productDetail!.listImage!.length : 0;
      default:
        return 0;
    }
  }
}
