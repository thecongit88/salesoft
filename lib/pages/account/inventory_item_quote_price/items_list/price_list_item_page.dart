import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/inventory_product_model.dart';
import 'package:sale_soft/model/price_list_item.dart';
import 'package:sale_soft/model/price_list_object.dart';
import 'package:sale_soft/model/price_list_option.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/choose_items/inventory_item_quote_price_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/price_info_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/items_list/price_list_item_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/send_price_quote/create_price_list_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/send_price_quote/create_price_list_page.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/widgets/app_bar_price_list_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/input_kiem_kho_with_plan_dialog.dart';
import 'package:sale_soft/widgets/input_text_dialog.dart';
import 'package:sale_soft/widgets/my_combo_box_widget.dart';

class PriceListItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PriceListItemPageState();
  }
}

class _PriceListItemPageState extends State<PriceListItemPage> {
  final controller = Get.find<PriceListItemsController>();

  @override
  Widget build(BuildContext context) {
    final controllerCart = Get.find<InventoryItemQuotePriceController>();
    List<InventroyItemModel> listItemsInCart = controllerCart.quotesCart;

    final TextStyle? summaryBottom = Theme.of(context)
        .textTheme
        .subtitle1
        ?.copyWith(fontSize: 16, color: AppColors.blue, fontWeight: FontWeight.bold);

    return Scaffold(
        appBar: AppBarPriceListWidget(
          title: "Thông tin báo giá",
          onBackAction: () {
            Navigator.pop(context, false);
          },
          onNextAction: () {
            List<PriceListItem> listItemsQuote = [];
            List<InventroyItemModel> listItemsInCart = controllerCart.quotesCart;
            if(listItemsInCart.length == 0) {
              showErrorToast("Không có sản phẩm báo giá.");
              return;
            } else {
              listItemsInCart.forEach((InventroyItemModel pro) {
                PriceListItem it = new PriceListItem(
                    pro.code!,
                    pro.name!,
                    pro.donGiaBaoGia,
                    pro.soluongBaoGia.toDouble(),
                    pro.promotion,
                    pro.ghiChu ?? "",
                    pro.unit ?? "-"
                );
                listItemsQuote.add(it);
                print("Item: ${pro.code} Note: ${pro.ghiChu} KM: ${pro.promotion}");
              });
            }
            PriceListObject priceListObject = controller.argument!.priceListObject!;
            priceListObject.Lists = listItemsQuote;
            priceListObject.TongTien = controller.totalAmount.value;
            Get.toNamed(
              ERouter.createPriceListPage.name,
              arguments: PriceListObjectArgument(priceListObject: priceListObject)
            );
          },
        ),
        body: controller.obx((data) {
          int nL = listItemsInCart.length;
          return nL == 0 ?
              Center(
                child: SizedBox(
                  height: 100,
                  child: Text("Không có sản phẩm nào báo giá."),
                ),
              )
              :
            Container(
            padding: const EdgeInsets.all(8),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                    child: controllerCart.obx((data){
                      return Container( 
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: nL,
                          itemBuilder: (context, index) {
                            final InventroyItemModel item = listItemsInCart[index];
                            return _InventoryItemWidget(
                              inventroyItem: item,
                              backgroundColor: index % 2 == 0
                                  ? AppColors.grey50.withOpacity(0.1)
                                  : null,
                            );
                          },
                        ),
                        margin: const EdgeInsets.only(top: 60),
                      );
                    })
                ),
                MyComboBox<PriceListOption>(
                  hint: 'Chọn mức giá (mặc định giá lẻ)',
                  value: controller.chinhSachGia,
                  items: controller.dsChinhSachGia,
                  bindTitle: (item) => item.Name,
                  onChanged: (value) {
                    //chọn dropdown giá lẻ hoặc giá sỉ
                    if (value == null) return;
                    controller.setChinhSachGia(value);
                    //reset các giá đã thay đổi trong product list items
                    listItemsInCart.forEach((it) {
                      it.isSelected = false;
                    });
                  },
                ),
              ],
            ),
          );
        }),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 0.5, color: AppColors.grey60),
            ),
            color: AppColors.blue50,
          ),
          child: controller.obx((data) {
            controller.calcTotalInItemList(listItemsInCart);
            return Row(children: [
              Text(
                'Tổng: ',
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: summaryBottom,
              ),
              Text("${controller.totalQty.value}",
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: summaryBottom,
              ),
              Expanded(
                child: Text('${controller.totalAmount.value.toAmountFormat()} đ',
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: summaryBottom,
                  textAlign: TextAlign.end,
                ),
              ),
            ]);
          }),
        )
    );
  }
}

class _InventoryItemWidget extends StatelessWidget {
  const _InventoryItemWidget({
    Key? key,
    this.onPress,
    required this.inventroyItem,
    this.backgroundColor,
  }) : super(key: key);

  final Function()? onPress;
  final InventroyItemModel inventroyItem;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    var controllerCart = Get.find<InventoryItemQuotePriceController>();
    var controller = Get.find<PriceListItemsController>();
    ///qty cho thay đổi màu sắc phía bên trái từng item
    double qty = inventroyItem.quantity ?? 0;

    ///thay đổi giá sản phẩm theo loại khách hàng, mặc định là giá sỉ
    //nếu chọn loại giá, Price0 là giá sỉ và Price là giá lẻ - EndUser, mặc định là giá lẻ Price
    /*if(controller.chinhSachGia != null) {
      if(inventroyItem.isSelected == false) {
        inventroyItem.donGiaBaoGia = controller.chinhSachGia!.Code != controller.giaSi ? inventroyItem.Price! : inventroyItem.Price0!;
      }
    } else {
      if(inventroyItem.isSelected == false) {
        //nếu không nhập giá từ hộp popup, mặc định là giá lẻ Price
        inventroyItem.donGiaBaoGia = inventroyItem.Price ?? 0;
      }
    }*/


    if(inventroyItem.isSelected == false) {
      //nếu chọn loại giá, Price0 là giá sỉ và Price là giá lẻ - EndUser, mặc định là giá lẻ Price
      if(controller.chinhSachGia != null) {
        inventroyItem.donGiaBaoGia = controller.chinhSachGia!.Code != controller.giaSi ? inventroyItem.Price! : inventroyItem.Price0!;
      } else {
        //nếu không nhập giá từ hộp popup, mặc định là giá lẻ Price
        inventroyItem.donGiaBaoGia = inventroyItem.Price ?? 0;
      }
    }


    ///phục vụ cho việc hiển thị popup nhập số lượng, đơn giá, khuyến mãi
    InventoryProductModel currentItem = new InventoryProductModel(
        ten: inventroyItem.name,
        ma: inventroyItem.code,
        unit: inventroyItem.unit,
        quantity: inventroyItem.quantity ?? 0
    );

    return InkWellWidget(
        onPress: onPress,
        child: Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  stops: [0.012, 0.012],
                  colors: [qty > 0 ? AppColors.green : AppColors.grey300, Color(0xFFfdfdfd)]
              ),
              borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      inventroyItem.code ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWellWidget(
                          child: Icon(
                            Icons.delete_rounded, color: AppColors.grey300,
                          ),
                          onPress: () {
                            confirmDeleteItemBaoGia(inventroyItem, context);
                          },
                        ),
                        AppConstant.spaceHorizontalSmallExtraExtraExtra,
                        InkWellWidget(
                          child: Icon(
                            Icons.wysiwyg_rounded, color: AppColors.orange,
                          ),
                          onPress: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return InputTextDialog(
                                    title: 'Ghi chú: ${inventroyItem.code}',
                                    value: "${inventroyItem.ghiChu ?? ""}",
                                    callback: (value) {
                                      inventroyItem.ghiChu = value;
                                      controller.update();
                                    },
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                AppConstant.spaceVerticalSmallExtra,
                Text(
                  inventroyItem.name ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontSize: 15.sp, height: 1.3, color: AppColors.grey),
                ),

                inventroyItem.ghiChu != null && inventroyItem.ghiChu != "" ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppConstant.spaceVerticalSmallExtra,
                        Text("Ghi chú: ${inventroyItem.ghiChu ?? ''}",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(fontSize: 15.sp, height: 1.3, color: AppColors.orange),
                        )
                      ],
                    )
                 :
                SizedBox(height: 0,),

                Column(
                  children: [
                    AppConstant.spaceVerticalSmall,
                    Divider(
                      thickness: 0.25,
                      color: AppColors.grey50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              inventroyItem.soluongBaoGia <= 0 ? SizedBox(height: 0,) : Row(
                                children: [
                                  InkWellWidget(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                                      decoration: BoxDecoration(
                                          color: AppColors.blue100,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.white, width: 1.8)),
                                      child: Center(
                                        child: Text("${inventroyItem.soluongBaoGia}",
                                          style: Theme.of(context).textTheme.bodyText1?.copyWith(),
                                        ),
                                      ),
                                    ),
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return InputKiemKhoWithPlanDialog(
                                                inventroyItemPlan: currentItem,
                                                value: inventroyItem.soluongBaoGia.toDouble(),
                                                type: InputNumberTypeKiemKho.QUANTITY,
                                                title: "Số lượng:",
                                                callback: (newQuantity) {
                                                  inventroyItem.soluongBaoGia = newQuantity.toInt();
                                                  controllerCart.calcQuoteCart4Item(inventroyItem);
                                                  controller.update();
                                                });
                                          }
                                      );
                                    },
                                  ),
                                  AppConstant.spaceHorizontalSmall,
                                  Text(
                                    'x',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(fontSize: 15.sp),
                                  ),
                                  AppConstant.spaceHorizontalSmall,
                                  InkWellWidget(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                                      decoration: BoxDecoration(
                                          color: AppColors.blue100,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.white, width: 1.8)),
                                      child: Center(
                                        child: Text("${formatCurrency(inventroyItem.donGiaBaoGia)}",
                                          style: Theme.of(context).textTheme.bodyText1?.copyWith(),
                                        ),
                                      ),
                                    ),
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return InputKiemKhoWithPlanDialog(
                                                inventroyItemPlan: currentItem,
                                                value: inventroyItem.donGiaBaoGia,
                                                type: InputNumberTypeKiemKho.PRICE,
                                                title: "Nhập đơn giá:",
                                                callback: (newPrice) {
                                                  inventroyItem.donGiaBaoGia = newPrice;
                                                  //đánh dấu là item này đã thay đổi giá
                                                  inventroyItem.isSelected = true;
                                                  //tính tổng ở bottom
                                                  controllerCart.calcQuoteCart4Item(inventroyItem);
                                                  controller.update();
                                                });
                                          }
                                      );
                                    },
                                  ),
                                  AppConstant.spaceHorizontalSmall,
                                  Text(
                                    'đ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'KM:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(fontSize: 16.sp),
                              ),
                              AppConstant.spaceHorizontalSmall,
                              InkWellWidget(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                                decoration: BoxDecoration(
                                    color: AppColors.blue100,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.white, width: 1.8)),
                                child: Center(
                                  child: Text("${inventroyItem.promotion>100 ? formatCurrency(inventroyItem.promotion) : showQty(inventroyItem.promotion)}",
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(),
                                  ),
                                ),
                              ),
                              onPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return InputKiemKhoWithPlanDialog(
                                          inventroyItemPlan: currentItem,
                                          value: inventroyItem.promotion,
                                          type: InputNumberTypeKiemKho.PERCENTAGE,
                                          title: "Nhập khuyến mãi:",
                                          callback: (newPromotion) {
                                            inventroyItem.promotion = newPromotion;
                                            controller.update();
                                          });
                                    }
                                );
                              },
                            ),
                              AppConstant.spaceHorizontalSmall,
                              Text(
                                inventroyItem.promotion <= 100 ? '%' : "đ", /* chú ý đoạn này nếu khuyến mãi > 100 thì sẽ là tiền */
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
        )
    );
  }

  void confirmDeleteItemBaoGia(InventroyItemModel product, BuildContext context) {
    final controllerCart = Get.find<InventoryItemQuotePriceController>();
    final controller = Get.find<PriceListItemsController>();
    List<InventroyItemModel> listItemsInCart = controllerCart.quotesCart;
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Đồng ý"),
      onPressed: () {
        controller.removeItemInItemList(product, listItemsInCart);
        controller.calcTotalInItemList(listItemsInCart);
        Get.back();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Bỏ qua"),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thông báo"),
      //content: Text("Bạn có muốn bỏ kiểm tồn sản phẩm ${product.ma} không?", style: TextStyle(height: 1.5),),
      content: RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.black87, height: 1.5),
              children: [
                TextSpan(
                  text: "Bạn có muốn xóa sản phẩm: ",
                ),
                TextSpan(
                  text: "${product.code} - ${product.name}",
                  style: TextStyle(fontWeight: FontWeight.bold,),
                ),
                TextSpan(
                  text: " không?",
                )
              ])
      ),
      actions: [
        cancelButton,
        okButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
