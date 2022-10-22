import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/order_detail_model.dart';
import 'package:sale_soft/model/order_model.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_controller.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiptDetailPage extends StatefulWidget {
  String chungtu;
  OrderModel? itOrderModel;
  String? type;
  ReceiptDetailPage(this.chungtu, {this.itOrderModel, this.type});

  @override
  State<StatefulWidget> createState() {
    return ReceiptDetailState();
  }
}

class ReceiptDetailState extends State<ReceiptDetailPage>
    with AutomaticKeepAliveClientMixin<ReceiptDetailPage> {
  final controller = Get.put(ReceiptDetailController());
  String? trangThaiHoaDon;
  String title = "Chi tiết chứng từ";

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if( widget.type! == AppConstant.otHoaDonXuatHang) {
      trangThaiHoaDon = widget.itOrderModel!.ttXuatKho;
      title = "Chi tiết phiếu xuất";
    } else if( widget.type! == AppConstant.otPhieuDatHang) {
      trangThaiHoaDon = widget.itOrderModel!.ttDatHang;
      title = "Chi tiết phiếu đặt hàng";
    } else {
      trangThaiHoaDon = widget.itOrderModel!.ttDatHang;
      title = "Chi tiết hóa đơn bán hàng";
    }

    //lấy chi tiết thông tin hóa đơn
    controller.code = widget.chungtu;
    controller.getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return controller.obx((listData) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.orItemDetailBg,
          borderRadius: BorderRadius.all(
              Radius.circular(4.r)),
        ),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text: 'Số phiếu: ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: AppColors.orHeadTitle, fontSize: 17.sp),
                          children: [
                            TextSpan(
                              text: widget.chungtu,
                              style: TextStyle(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp),
                            )
                          ])
                  ),
                  Spacer(),
                  InkWellWidget(
                    child: Icon(Icons.highlight_remove, color: AppColors.orItemDetailProduct,),
                    onPress: () {
                      Get.back(result: controller.retConfirmOrder);
                    },
                  )
                ],
              ),
              AppConstant.spaceVerticalSmallExtraExtraExtra,
              widget.type! == AppConstant.otHoaDonBanHang ?
              Container(
                width: 100.r,
                height: 32.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.all(
                        Radius.circular(4.r)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    )
                ),
                child: Text("Số lượng ${widget.itOrderModel?.soLuong!.toInt() ?? '0'}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white, fontSize: 12.5.sp),
                ),
              )
                  :
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppConstant.spaceVerticalSmallExtra,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90.w,
                        height: 32.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.grey300,
                            borderRadius: BorderRadius.all(
                                Radius.circular(4.r)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            )
                        ),
                        child: Text("Số lượng ${widget.itOrderModel?.soLuong!.toInt() ?? '0'}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.white, fontSize: 12.5.sp),
                        ),
                      ),
                      widget.type == AppConstant.otHoaDonXuatHang && widget.itOrderModel!.tinhTrang! != AppConstant.statusDaXuat ? Spacer() : SizedBox(width: 10,),
                      Container(
                        width: 90.w,
                        height: 32.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: widget.type == AppConstant.otHoaDonXuatHang ? AppColors.getStatusBgColorHoaDonXuat(widget.itOrderModel!.tinhTrang!) : AppColors.getOrderStatusBgColor(trangThaiHoaDon ?? ''),
                            borderRadius: BorderRadius.all(
                                Radius.circular(4.r)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            )
                        ),
                        child: Text("${trangThaiHoaDon ?? ''}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.white, fontSize: 12.5.sp),
                        ),
                      ),
                      widget.type == AppConstant.otHoaDonXuatHang ?
                      Spacer() : SizedBox(height: 0,),
                      widget.type == AppConstant.otHoaDonXuatHang && widget.itOrderModel!.tinhTrang! != AppConstant.statusDaXuat ?
                      InkWellWidget(
                        child: Container(
                            width: 100.w,
                            height: 32.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.r)),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 12,),
                                AppConstant.spaceHorizontalSmall,
                                Text("Xác nhận xuất",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(color: Colors.white, fontSize: 12.5.sp),
                                ),
                              ],
                            )
                        ),
                        onPress: () async {
                          //lấy chi tiết thông tin hóa đơn
                          controller.code = widget.chungtu;
                          final result  = await controller.confirmOrder(controller.code);
                          if(result == 1 || result == "1") {
                            widget.itOrderModel!.tinhTrang = AppConstant.statusDaXuat.toDouble();
                            controller.getOrderDetail();
                          }
                        },
                      ) : SizedBox(height: 0,),
                    ],
                  )
                ],
              ),
              AppConstant.spaceVerticalSmallExtraExtraExtra,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                  vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(const Radius.circular(4.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppConstant.spaceVerticalSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.type == AppConstant.otHoaDonBanHang ? SizedBox(height: 0,) :
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                  Icons.circle,
                                  color: widget.type == AppConstant.otHoaDonXuatHang ? AppColors.getStatusBgColorHoaDonXuat(widget.itOrderModel!.tinhTrang!).withOpacity(0.15) : AppColors.getOrderStatusBgColor(trangThaiHoaDon ?? '').withOpacity(0.15) ,
                                  size: 25.sp
                              ),
                              Icon(
                                  Icons.circle,
                                  color: widget.type == AppConstant.otHoaDonXuatHang ? AppColors.getStatusBgColorHoaDonXuat(widget.itOrderModel!.tinhTrang!) : AppColors.getOrderStatusBgColor(trangThaiHoaDon ?? ''),
                                  size: 13.sp
                              )
                            ],
                          ),
                        ),
                        Text("$title",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: AppColors.orMainTitle, fontSize: 18.sp),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.25,
                      color: AppColors.blue,
                      height: 23,
                    ),

                    Text("Ngày ${DateTimeHelper.dateToStringFormat(date: widget.itOrderModel != null ? widget.itOrderModel!.ngay : null)}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: AppColors.orTime, fontSize: 14.sp),
                    ),
                    AppConstant.spaceVerticalSmallExtra,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${widget.itOrderModel?.tenKhachHang ?? '- (không có mã k/h)'}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: AppColors.orMainTitle, fontSize: 15.sp),
                        ),
                        Spacer(),
                        Text("${widget.itOrderModel?.phatSinhCo!.toAmountFormat() ?? '-'} đ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: AppColors.orPrice, fontSize: 15.sp),
                        ),
                      ],
                    ),

                    widget.itOrderModel != null && widget.itOrderModel!.diaChi!.isNotEmpty ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppConstant.spaceVerticalSmallExtra,
                        Text("Đ/c: ${widget.itOrderModel?.diaChi} ",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: AppColors.orHeadTitle, fontSize: 15.sp, height: 1.2),
                        )
                      ],
                    ) : SizedBox(height: 0,),

                    AppConstant.spaceVerticalSmallExtra,
                    InkWellWidget(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phone: ",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: AppColors.orHeadTitle, fontSize: 15.sp),
                          ),
                          Expanded(
                            child: Text("${getNullOrEmptyValue(widget.itOrderModel?.dienThoai ?? '-')}",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(color: AppColors.blue, fontSize: 15.sp),
                              maxLines: 3,
                            ),
                          )
                        ],
                      ),
                      onPress: () {
                        if(widget.itOrderModel!.dienThoai!.isNotEmpty)
                          launch("tel:${widget.itOrderModel!.dienThoai!}");
                        else return;
                      },
                    ),

                    AppConstant.spaceVerticalSmallExtra,
                    InkWellWidget(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: ",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: AppColors.orHeadTitle, fontSize: 15.sp),
                          ),
                          Expanded(
                            child: Text("${getNullOrEmptyValue(widget.itOrderModel?.email ?? '-')}",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(color: AppColors.blue, fontSize: 15.sp),
                              maxLines: 3,
                            ),
                          )
                        ],
                      ),
                      onPress: () {
                        if(widget.itOrderModel!.email!.isNotEmpty)
                          launch("mailto:${widget.itOrderModel!.email!}");
                        else return;
                      },
                    ),
                    Divider(
                      thickness: 0.25,
                      color: AppColors.blue,
                      height: 23,
                    ),
                    ListView.builder(
                      itemCount: listData?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildItem(index, listData![index]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      );
    }, onEmpty: EmptyDataWidget(
      onReloadData: () {
        controller.getOrderDetail();
      },
    ));
  }

  Widget buildItem(int index, OrderDetailModel item) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${index+1} - ${item.Name}",
              style: TextStyle(
                  color: AppColors.orItemDetailProduct, fontWeight: FontWeight.w500, height: 1.3, fontSize: 14.5.sp)),
          AppConstant.spaceVerticalSmall,
          Row(
            children: [
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "SL: ",
                          style: TextStyle(
                              color: AppColors.orItemDetailProduct,
                              fontWeight: FontWeight.normal,
                              fontSize: 13.sp)),
                      TextSpan(
                          text: "${item.Quantity}",
                          style: TextStyle(
                              color: AppColors.orItemDetailProduct,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp)),
                      TextSpan(
                          text: "  x  ",
                          style: TextStyle(
                              color: AppColors.orItemDetailProduct,
                              fontWeight: FontWeight.normal,
                              fontSize: 13.sp)),
                      TextSpan(
                          text: "ĐG: ",
                          style: TextStyle(
                              color: AppColors.orItemDetailProduct,
                              fontWeight: FontWeight.normal,
                              fontSize: 13.sp)),
                      TextSpan(
                          text: "${(item.Price ?? 0.0).toAmountFormat()}",
                          style: TextStyle(
                              color: AppColors.orItemDetailProduct,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp)),
                      TextSpan(
                          text: "  ",
                          style: TextStyle(
                              color: AppColors.orItemDetailProduct,
                              fontWeight: FontWeight.normal,
                              fontSize: 13.sp)),
                      TextSpan(
                          text: "KM: ",
                          style: TextStyle(
                              color: AppColors.orItemDetailProduct,
                              fontWeight: FontWeight.normal,
                              fontSize: 13.sp)),
                      TextSpan(
                          text: "${(item.Promotion ?? 0.0).toAmountFormat()}",
                          style: TextStyle(
                              color: AppColors.orItemDetailProduct,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp))
                    ])),
              ),
              Text(
                "= ${(item.Total ?? 0.0).toAmountFormat()}",
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.orItemDetailProduct,),
              )
            ],
          ),
          AppConstant.spaceVerticalSmallMedium,
        ]);
  }
}
