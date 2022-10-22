import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/inventory_product_model.dart';
import 'package:sale_soft/model/product_info_model.dart';
import 'package:sale_soft/pages/account/kiem_kho_page/kiem_kho_controller.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/widgets/dash_line_widget.dart';
import 'package:sale_soft/widgets/expanded_widget.dart';
import 'package:sale_soft/widgets/filter_plans_widget.dart';
import 'package:sale_soft/widgets/filter_warehouse_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/input_kiem_kho_no_plan_dialog.dart';
import 'package:sale_soft/widgets/input_kiem_kho_with_plan_dialog.dart';
import 'package:sale_soft/widgets/search_widget.dart';

class KiemKhoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KiemKhoPagePage();
  }
}

class _KiemKhoPagePage extends State<KiemKhoPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final KiemKhoController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        elevation: 0,
        leading: BackButtonWidget(),
        backgroundColor: AppColors.blue,
        centerTitle: false,
        title: TitleAppBarWidget(
          title: "Kiểm kho",
        ),
      ),
      body: controller.obx((data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StepByStepWidget(
              documentExpanded: controller.documentExpanded,
              inventoryItemExpanded: controller.inventoryItemExpanded,
              saveOrderExpanded: controller.saveOrderExpanded,
              onClick: (step) {
                if(controller.warehouseSelected == null) {
                  showToast("Vui lòng chọn kho hàng.");
                  return;
                } else if(controller.getIsKiemKhoTheoKeHoach() == true && controller.planSelected == null) {
                  showToast("Vui lòng chọn kế hoạch.");
                  return;
                } else if(controller.getIsKiemKhoTheoKeHoach() == true && controller.getTotalAllProducts() <= 0) {
                  showToast("Không có sản phẩm cần kiểm kho trong kế hoạch này.");
                  return;
                }

                switch (step) {
                  case 1:
                    if(controller.hasChangedList() == true) {
                      confirmBackStep();
                    } else {
                      controller.setDocumentActive();
                    }
                    //controller.setDocumentActive();
                    break;
                  case 2:
                    controller.setInventoryItemActive();
                    break;
                  /*case 3:
                    controller.setSaveOrderActive();
                    break;*/
                }
              },
            ),
            //AppConstant.spaceVerticalSmallExtraExtraExtra,
            Expanded(
              child: controller.documentExpanded == true ?
              wdgStep01KeHoach()
                  :
              wdgStep02KiemHang()
            )
          ],
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _selectDate(BuildContext context) async {
    var controller = Get.find<KiemKhoController>();
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("vi", "VN"),
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        cancelText: 'Bỏ qua',
        confirmText: 'Đồng ý',
        builder: (context, child) {
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
        }
    );
    if (picked != null && picked != controller.deadlineDate) {
      controller.setDeadlineDate(picked);
    }
  }

  wdgHeader() {
    final double height = 40;
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blue200,
                border: Border(
                  right: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
              alignment: Alignment.center,
              height: height,
              child: Text("STT", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
            )
        ),
        Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blue200,
                border: Border(
                  right: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
              alignment: Alignment.center,
              height: height,
              child: Text("Sản phẩm", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
            )
        ),
        Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blue200,
                border: Border(
                  right: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
              alignment: Alignment.center,
              height: height,
              child: Text("SL", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
            )
        ),
        Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blue200,
                border: Border(
                  right: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
              alignment: Alignment.center,
              height: height,
              child: Text("DVT", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
            )
        )
      ],
    );
  }

  wdgListSanPhamKiemKho() {
    final KiemKhoController controller = Get.find();
    List<InventoryProductModel> list = controller.searchProductsByKey();
    int n = list.length;
    return
      Expanded(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(bottom: 60),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  InventoryProductModel item = list[index];
                  return InkWellWidget(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: AppConstant.kSpaceVerticalSmallExtra,
                        bottom: AppConstant.kSpaceVerticalSmallExtra,
                      ),
                      color: index % 2 != 0 ? AppColors.grey50.withOpacity(0.3) : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("${index+1}",
                              style: TextStyle(
                                  color: AppColors.orPrice,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14), textAlign: TextAlign.center,),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${item.ma}",
                                    style: TextStyle(
                                        color: AppColors.orPrice,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13, height: 1.2)),
                                Text("${item.ten}",
                                  style: TextStyle(
                                      color: AppColors.orPrice,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13, height: 1.2),
                                ),
                                /*Text("SL cũ: ${item.quantity}",
                                  style: TextStyle(
                                      color: AppColors.orPrice,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13, height: 1.2),
                                )*/
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text("${showQty(item.quantity)}",
                              style: TextStyle(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14, height: 1.2),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text("${item.unit}",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColors.orPrice,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13, height: 1.2)
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: item.checked == true ?
                              InkWellWidget(
                                child: Icon(Icons.cancel, color: AppColors.grey50,),
                              )
                                  :
                              InkWellWidget(
                                child: Icon(Icons.cancel, color: AppColors.red,),
                                onPress: () {
                                  confirmDeleteTonKho(item);
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    onPress: () {
                      /*showDialog(
                          context: context,
                          builder: (context) {
                            return InputKiemKhoDialog(
                                inventroyItemPlan: item,
                                value: 0, //controller.prepaid,
                                type: InputNumberTypeKiemKho.QUANTITY,
                                title: "Số lượng kiểm",
                                callback: (newQuantity) {
                                  item.soLuongKiemKho = newQuantity;
                                  controller.sortBySoLuongKiemKho();
                                  controller.updateUi();
                                });
                          }
                      );*/
                    },
                  );
                },
                itemCount: n
            )
          )
        ),
    );
  }

  Widget wdgStep01KeHoach() {
    final KiemKhoController controller = Get.find();
    return Container(
        padding: const EdgeInsets.all(15),
        child: ListView(

          children: [
            _OneLineInfoWidget(
              title: "Ngày kiểm",
              value: DateTimeHelper.dateToStringFormat(date: DateTime.now()),
            ),
            AppConstant.spaceVerticalSmallMedium,
            AppConstant.spaceVerticalSmallMedium,

            ///Chọn kho hàng
            StoreDropdownWidget(),

            ///kiểm kho theo kế hoạch
            /*AppConstant.spaceVerticalSmallMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CheckBoxButtonWidget(
                  title: 'Kiểm kho theo kế hoạch',
                  onPress: (value) {
                    controller.setIsKiemKhoTheoKeHoach(value);
                  },
                  isChecked: controller.isKiemKhoTheoKeHoach,
                )
              ],
            ),
            controller.getIsKiemKhoTheoKeHoach() == true ?
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppConstant.spaceVerticalSmallMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Có",
                      style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16.sp),),
                    controller.isLoadingPlan.value == true ?
                    AppColors.pleaseWait()
                        :
                    Text(" ${controller.listAllPlansByKho.length} ",
                      style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16.sp, color: AppColors.red, fontWeight: FontWeight.bold),),
                    Text("kế hoạch kiểm kho.",
                      style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16.sp),)
                  ],
                ),
                AppConstant.spaceVerticalSmallMedium,
                ///Chọn kế hoạch
                PlansDropdownWidget(),
                AppConstant.spaceVerticalSmallMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Có",
                      style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16.sp),),
                    controller.isLoadingProduct.value == true ?
                    AppColors.pleaseWait()
                        :
                    Text(" ${controller.listAllProductsByPlan.length} ",
                        style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16.sp, color: AppColors.red, fontWeight: FontWeight.bold)),
                    Text("hàng hóa cần kiểm kho.",
                      style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16.sp),)
                  ],
                ),
              ],
            ) : SizedBox(height: 0,),*/

            AppConstant.spaceVerticalSmallExtraExtraExtra,
            AppConstant.spaceVerticalSmallExtraExtraExtra,
            ///tiếp tục
            InkWellWidget(
              child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.shade200,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ],
                      color: controller.warehouseSelected == null || (controller.getIsKiemKhoTheoKeHoach() == true && controller.getTotalAllProducts() <= 0) ? AppColors.grey300 : AppColors.blue
                  ),
                  alignment: Alignment.center,
                  child:
                  controller.isLoadingProduct.value == true ?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppColors.pleaseWait(color: Colors.white),
                      Text(
                        'Đang xử lý',
                        style: TextStyle(fontSize:  14.sp, color: Colors.white),
                      ),
                      SizedBox(width: 7.sp),
                      Icon(Icons.arrow_right_alt_sharp, color: Colors.white, size:  17.sp),
                    ],
                  ) :
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bước tiếp theo',
                        style: TextStyle(fontSize:  14.sp, color: Colors.white),
                      ),
                      SizedBox(width: 7.sp),
                      Icon(Icons.arrow_right_alt_sharp, color: Colors.white, size:  17.sp),
                    ],
                  )
              ),
              onPress: () async {
                if(controller.warehouseSelected == null) {
                  showToast("Vui lòng chọn kho hàng.");
                  return;
                } else if(controller.getIsKiemKhoTheoKeHoach() == true && controller.planSelected == null) {
                  showToast("Vui lòng chọn kế hoạch.");
                  return;
                } else if(controller.getIsKiemKhoTheoKeHoach() == true && controller.getTotalAllProducts() <= 0) {
                  showToast("Không có sản phẩm cần kiểm kho trong kế hoạch này.");
                  return;
                }
                await controller.getListProductsByPlan(controller.warehouseSelected!.Ma!, "all");
                controller.setInventoryItemActive();
              },
            )
          ],
        )
    );
  }

  Widget wdgStep02KiemHang() {
    final KiemKhoController controller = Get.find();
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: SearchWidget(
                  hintText: "Tìm mã hoặc tên hàng hóa",
                  textEditingController: controller.textEditController,
                  onChange: (keyword) async {
                    controller.searchProductsByKey();
                    controller.update();
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.qr_code_scanner,
                    ),
                    onPressed: () async {
                      int camera = -1; ///sử dụng camera sau
                      String? qrCodeResult;
                      ScanResult codeSanner = await BarcodeScanner.scan(
                        options: ScanOptions(
                            useCamera: camera,
                            strings:
                            const {
                              "cancel": "Đóng",
                            }
                        ),
                      );
                      qrCodeResult = codeSanner.rawContent;
                      //qrCodeResult = "MB9003";
                      //qrCodeResult = "https://www.diawi.com/";
                      //print("Qr code result: ${hasValidUrl(qrCodeResult)}");

                      ///Chú ý: Đoạn code check khi bắn mã qr để Thêm hàng khi tạo phiếu đặt hàng
                      /*if(controller.argument != null) {
                                      controller.textEditController.text = qrCodeResult;
                                      controller.fetchInventoryItem();
                                      controller.update();
                                      return;
                                    }*/

                      //controller.textEditController.text = qrCodeResult;

                      if(qrCodeResult.isNotEmpty) {
                        ///kiểm hàng cần kế hoạch
                        if(controller.isKiemKhoTheoKeHoach.value == true) {
                          InventoryProductModel currentItem = controller.getItemScanned(qrCodeResult);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return InputKiemKhoWithPlanDialog(
                                    inventroyItemPlan: currentItem,
                                    value: 0, //currentItem.quantity,
                                    type: InputNumberTypeKiemKho.QUANTITY,
                                    title: "Số lượng kiểm:",
                                    callback: (newQuantity) {
                                      controller.setSoLuongTonKhoPlan(newQuantity);
                                    });
                              }
                          );
                        } else {
                          ///kiểm hàng ko cần kế hoạch
                          showDialog(
                              context: context,
                              builder: (context) {
                                return InputKiemKhoNoPlanDialog(
                                    productCode: qrCodeResult,
                                    value: 0,
                                    type: InputNumberTypeKiemKho2.QUANTITY,
                                    title: "Số lượng kiểm:",
                                    callback: (double newQuantity, ProductInfoModel item) {
                                      controller.setSoLuongTonKhoNoPlan(newQuantity, item);
                                    });
                              }
                          );
                        }
                      } else {
                        showErrorToast("Không tìm thấy sản phẩm.");
                      }
                    },
                  ),
                ),
              ),

              ///tạm thời,
              AppConstant.spaceVerticalSmallExtraExtraExtra,
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //wdgTamThoi(),
                  SizedBox(width: 8,),
                  Text("Đã kiểm ${controller.getTotalDaKiem()}", style: TextStyle(color: AppColors.blue),),
                  Spacer(),
                  InkWellWidget(
                    child: Row(
                      children: [
                        Icon(Icons.open_in_new, size: 18.sp, color: AppColors.blue),
                        SizedBox(width: 5,),
                        Text("Chọn sản phẩm", style: TextStyle(color: AppColors.blue),),
                        SizedBox(width: 8,)
                      ],
                    ),
                    onPress: () async {
                      ///khi bấm tìm thêm sản phẩm ở màn hình kiểm kho
                      InventroyItemModel item = new InventroyItemModel();
                      item.code = AppConstant.kiem_kho;
                      controller.listItem.clear();
                      controller.listItem.add(item);
                      List<InventroyItemModel> selectedList = await Get.toNamed(
                          ERouter.inventoryItem.name,
                          arguments: controller.listItem
                      );

                      ///kiểm hàng ko cần kế hoạch
                      showDialog(
                          context: context,
                          builder: (context) {
                            return InputKiemKhoNoPlanDialog(
                                productCode: selectedList[0].code,
                                value: 0,
                                type: InputNumberTypeKiemKho2.QUANTITY,
                                title: "Số lượng kiểm:",
                                callback: (double newQuantity, ProductInfoModel item) {
                                  controller.setSoLuongTonKhoNoPlan(newQuantity, item);
                                });
                          }
                      );
                    },
                  )
                ],
              ),
              ///tạm thời

              ///checkbox filter đã kiểm và chưa kiểm dành cho kiểm kho theo kế hoạch
              //controller.getIsKiemKhoTheoKeHoach() ? _FilterWidget() : SizedBox(height: 0,),
              AppConstant.spaceVerticalSmallExtraExtraExtra,
              wdgListSanPhamKiemKho()
            ],
          ),
          wdgActionKiemHang()
        ],
      ),
    );
  }

  Widget wdgActionKiemHang() {
    final KiemKhoController controller = Get.find();
    return Container(
      width: 270,
      color: Colors.transparent,
      /*decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
              color: AppColors.orItemDetailProduct,
              width: 1.0,
            ),
            bottom: BorderSide(width: 0)
        ),
      ),*/
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      height: 55,
      child: Row(
        children: [
          Expanded(
            child: InkWellWidget(
              onPress: () {
                if(controller.hasChangedList() == true) {
                  confirmBackStep();
                } else {
                  controller.setDocumentActive();
                }
              },
              child: Container(
                  alignment: Alignment.center,decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppColors.grey300,
                        offset: Offset(2, 3),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.notifi_color_6,
                        AppColors.notifi_color_6
                      ]
                  )
              ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 17.sp),
                      SizedBox(width: 7.sp),
                      Text(
                        'Bước trước',
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      )
                    ],
                  )
              ),
            ),
          ),
          VerticalDivider(
              color: AppColors.grey300,
              thickness: 1
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                var result = await controller.createKiemKho();
                if(result == "1" || result == 1) {
                  showSuccessToast("Kiểm kho thành công.");
                  return;
                } else {
                  showErrorToast("Có lỗi khi tạo kiểm kho.");
                  return;
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppColors.grey300,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ],
                      color: AppColors.blue
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_outlined, color: Colors.white, size:  17.sp),
                      SizedBox(width: 7.sp),
                      Text(
                        'Cập nhật',
                        style: TextStyle(fontSize:  14.sp, color: Colors.white),
                      )
                    ],
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

  wdgTamThoi() {
    final KiemKhoController controller = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.qr_code_scanner,
          ),
          onPressed: () async {
            int camera = -1; ///sử dụng camera sau
            String? qrCodeResult;
            ScanResult codeSanner = await BarcodeScanner.scan(
              options: ScanOptions(
                  useCamera: camera,
                  strings:
                  const {
                    "cancel": "Đóng",
                  }
              ),
            );
            qrCodeResult = codeSanner.rawContent;
            qrCodeResult = "MB9003";

            if(qrCodeResult.isNotEmpty) {
              ///kiểm hàng cần kế hoạch
              if(controller.isKiemKhoTheoKeHoach.value == true) {
                InventoryProductModel currentItem = controller.getItemScanned(qrCodeResult);
                if(checkProductCode(qrCodeResult, currentItem) == false) return;
                showDialog(
                    context: context,
                    builder: (context) {
                      return InputKiemKhoWithPlanDialog(
                          inventroyItemPlan: currentItem,
                          value: 0, //currentItem.quantity,
                          type: InputNumberTypeKiemKho.QUANTITY,
                          title: "Số lượng kiểm:",
                          callback: (newQuantity) {
                            controller.setSoLuongTonKhoPlan(newQuantity);
                          });
                    }
                );
              } else {
                ///kiểm hàng ko cần kế hoạch
                showDialog(
                    context: context,
                    builder: (context) {
                      return InputKiemKhoNoPlanDialog(
                          productCode: qrCodeResult,
                          value: 0,
                          type: InputNumberTypeKiemKho2.QUANTITY,
                          title: "Số lượng kiểm:",
                          callback: (double newQuantity, ProductInfoModel item) {
                            controller.setSoLuongTonKhoNoPlan(newQuantity, item);
                          });
                    }
                );
              }
            } else {
              showErrorToast("Không tìm thấy sản phẩm.");
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.qr_code_scanner,
          ),
          onPressed: () async {
            int camera = -1; ///sử dụng camera sau
            String? qrCodeResult;
            ScanResult codeSanner = await BarcodeScanner.scan(
              options: ScanOptions(
                  useCamera: camera,
                  strings:
                  const {
                    "cancel": "Đóng",
                  }
              ),
            );
            qrCodeResult = codeSanner.rawContent;
            qrCodeResult = "MB9007";

            if(qrCodeResult.isNotEmpty) {
              ///kiểm hàng cần kế hoạch
              if(controller.isKiemKhoTheoKeHoach.value == true) {
                InventoryProductModel currentItem = controller.getItemScanned(qrCodeResult);
                if(checkProductCode(qrCodeResult, currentItem) == false) return;
                showDialog(
                    context: context,
                    builder: (context) {
                      return InputKiemKhoWithPlanDialog(
                          inventroyItemPlan: currentItem,
                          value: 0, //currentItem.quantity,
                          type: InputNumberTypeKiemKho.QUANTITY,
                          title: "Số lượng kiểm:",
                          callback: (newQuantity) {
                            controller.setSoLuongTonKhoPlan(newQuantity);
                          });
                    }
                );
              } else {
                ///kiểm hàng ko cần kế hoạch
                showDialog(
                    context: context,
                    builder: (context) {
                      return InputKiemKhoNoPlanDialog(
                          productCode: qrCodeResult,
                          value: 0,
                          type: InputNumberTypeKiemKho2.QUANTITY,
                          title: "Số lượng kiểm:",
                          callback: (double newQuantity, ProductInfoModel item) {
                            controller.setSoLuongTonKhoNoPlan(newQuantity, item);
                          });
                    }
                );
              }
            } else {
              showErrorToast("Không tìm thấy sản phẩm.");
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.qr_code_scanner,
          ),
          onPressed: () async {
            int camera = -1; ///sử dụng camera sau
            String? qrCodeResult;
            ScanResult codeSanner = await BarcodeScanner.scan(
              options: ScanOptions(
                  useCamera: camera,
                  strings:
                  const {
                    "cancel": "Đóng",
                  }
              ),
            );
            qrCodeResult = codeSanner.rawContent;
            qrCodeResult = "54001W";

            if(qrCodeResult.isNotEmpty) {
              ///kiểm hàng cần kế hoạch
              if(controller.isKiemKhoTheoKeHoach.value == true) {
                InventoryProductModel currentItem = controller.getItemScanned(qrCodeResult);
                if(checkProductCode(qrCodeResult, currentItem) == false) return;
                showDialog(
                    context: context,
                    builder: (context) {
                      return InputKiemKhoWithPlanDialog(
                          inventroyItemPlan: currentItem,
                          value: 0, //currentItem.quantity,
                          type: InputNumberTypeKiemKho.QUANTITY,
                          title: "Số lượng kiểm:",
                          callback: (newQuantity) {
                            controller.setSoLuongTonKhoPlan(newQuantity);
                          });
                    }
                );
              } else {
                ///kiểm hàng ko cần kế hoạch
                showDialog(
                    context: context,
                    builder: (context) {
                      return InputKiemKhoNoPlanDialog(
                          productCode: qrCodeResult,
                          value: 0,
                          type: InputNumberTypeKiemKho2.QUANTITY,
                          title: "Số lượng kiểm:",
                          callback: (double newQuantity, ProductInfoModel item) {
                            controller.setSoLuongTonKhoNoPlan(newQuantity, item);
                          });
                    }
                );
              }
            } else {
              showErrorToast("Không tìm thấy sản phẩm.");
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.qr_code_scanner,
          ),
          onPressed: () async {
            int camera = -1; ///sử dụng camera sau
            String? qrCodeResult;
            ScanResult codeSanner = await BarcodeScanner.scan(
              options: ScanOptions(
                  useCamera: camera,
                  strings:
                  const {
                    "cancel": "Đóng",
                  }
              ),
            );
            qrCodeResult = codeSanner.rawContent;
            qrCodeResult = "KY1151";

            if(qrCodeResult.isNotEmpty) {
              ///kiểm hàng cần kế hoạch
              if(controller.isKiemKhoTheoKeHoach.value == true) {
                InventoryProductModel currentItem = controller.getItemScanned(qrCodeResult);
                if(checkProductCode(qrCodeResult, currentItem) == false) return;
                showDialog(
                    context: context,
                    builder: (context) {
                      return InputKiemKhoWithPlanDialog(
                          inventroyItemPlan: currentItem,
                          value: 0, //currentItem.quantity,
                          type: InputNumberTypeKiemKho.QUANTITY,
                          title: "Số lượng kiểm:",
                          callback: (newQuantity) {
                            controller.setSoLuongTonKhoPlan(newQuantity);
                          });
                    }
                );
              } else {
                ///kiểm hàng ko cần kế hoạch
                showDialog(
                    context: context,
                    builder: (context) {
                      return InputKiemKhoNoPlanDialog(
                          productCode: qrCodeResult,
                          value: 0,
                          type: InputNumberTypeKiemKho2.QUANTITY,
                          title: "Số lượng kiểm:",
                          callback: (double newQuantity, ProductInfoModel item) {
                            controller.setSoLuongTonKhoNoPlan(newQuantity, item);
                          });
                    }
                );
              }
            } else {
              showErrorToast("Không tìm thấy sản phẩm.");
            }
          },
        ),
      ],
    );
  }

  checkProductCode(String currentCode, InventoryProductModel currentItem) {
    final KiemKhoController controller = Get.find();
    if(currentItem.ma == null || currentItem.ma.toString().trim() == "" || currentItem.ma.toString().trim() == "null") {
      Get.dialog(
        AlertDialog(
          title: const Text('Thông báo'),
          content: RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black87, height: 1.5),
                  children: [
                    TextSpan(
                      text: "Sản phẩm ",
                    ),
                    TextSpan(
                      text: "$currentCode",
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    ),
                    TextSpan(
                      text: " không thuộc về kế hoạch kiểm kho ",
                    ),
                    TextSpan(
                      text: "${controller.planSelected!.Ten}",
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    ),
                  ])
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  void confirmDeleteTonKho(InventoryProductModel product) {
    final KiemKhoController controller = Get.find();
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Đồng ý"),
      onPressed: () { 
        controller.removeKiemTon(product.ma!);
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
                  text: "Bạn có muốn bỏ kiểm tồn sản phẩm: ",
                ),
                TextSpan(
                  text: "${product.ma} - ${product.ten}",
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

  void confirmBackStep() {
    final KiemKhoController controller = Get.find();

    Widget okButton = InkWellWidget(
      onPress: () async {
        var result = await controller.createKiemKho();
        if(result == "1" || result == 1) {
          showSuccessToast("Kiểm kho thành công.");
        } else {
          showErrorToast("Có lỗi khi tạo kiểm kho.");
        }
        Get.back();
        controller.setDocumentActive();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            shape: BoxShape.rectangle),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.save, size: 15, color: Colors.white,),
            AppConstant.spaceHorizontalSmallExtra,
            Text(
              "Quay về và lưu dữ liệu",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    Widget cancelButton = InkWellWidget(
      onPress: () async {
        Get.back();
        controller.setDocumentActive();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            shape: BoxShape.rectangle),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.cancel, size: 15, color: Colors.white,),
            AppConstant.spaceHorizontalSmallExtra,
            Text(
              "Quay về và không lưu dữ liệu",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );

    Widget ignoreButton = InkWellWidget(
      onPress: () async {
        Get.back();
      },
      child: Center(
        child: Text(
          "Đóng lại",
          style: TextStyle(color: AppColors.grey300), textAlign: TextAlign.center,
        ),
      )
    );

    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.all(15),
      actions: [
        okButton,
        AppConstant.spaceVerticalSmallExtraExtraExtra,
        cancelButton,
        AppConstant.spaceVerticalSmallExtraExtraExtra,
        ignoreButton,
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

class _FilterWidget extends StatelessWidget {
  const _FilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KiemKhoController controller = Get.find();
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CheckBoxButtonWidget(
            title: '${controller.getTotalDaKiem()}/${controller.getTotalAllProducts()} sản phẩm đã kiểm',
            onPress: (value) {
              controller.searchProductsByKey();
              controller.update();
            },
            isChecked: controller.isSelectedDaKiem,
          ),
          _CheckBoxButtonWidget(
            title: '${controller.getTotalChuaKiem()}/${controller.getTotalAllProducts()} sản phẩm chưa kiểm',
            onPress: (value) {
              controller.searchProductsByKey();
              controller.update();
            },
            isChecked: controller.isSelectedChuaKiem,
          )
        ],
      ),
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

class _OneLineInfoWidget extends StatelessWidget {
  const _OneLineInfoWidget({
    Key? key,
    this.title,
    this.value,
  }) : super(key: key);

  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("$title",
          style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16.sp),),
        Spacer(),
        Text("$value",
          style: Theme.of(context).textTheme.caption?.copyWith(
          fontWeight: FontWeight.bold, fontSize: 16.sp
          )
        )
      ],
    );
  }
}

class _StepByStepWidget2 extends StatelessWidget {
  const _StepByStepWidget2(
      {Key? key,
        required this.documentExpanded,
        required this.inventoryItemExpanded,
        required this.saveOrderExpanded,
        required this.onClick})
      : super(key: key);
  final bool documentExpanded;
  final bool inventoryItemExpanded;
  final bool saveOrderExpanded;
  final Function(int step) onClick;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepWidget(
            number: "1",
            title: "Kế hoạch",
            isActive: documentExpanded,
            onClick: () {
              onClick(1);
            },
          ),
          _DashWidget(),
          _StepWidget(
            onClick: () {
              onClick(2);
            },
            number: "2",
            isActive: inventoryItemExpanded,
            title: "Hàng hóa",
          ),
          /*_DashWidget(),
          _StepWidget(
            onClick: () {
              onClick(3);
            },
            isActive: saveOrderExpanded,
            number: "3",
            title: "Lưu phiếu",
          ),*/
        ],
      ),
    );
  }
}

class _StepByStepWidget extends StatelessWidget {
  const _StepByStepWidget(
      {Key? key,
        required this.documentExpanded,
        required this.inventoryItemExpanded,
        required this.saveOrderExpanded,
        required this.onClick})
      : super(key: key);
  final bool documentExpanded;
  final bool inventoryItemExpanded;
  final bool saveOrderExpanded;
  final Function(int step) onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.orItemDetailBg,
      padding: EdgeInsets.only(top: AppConstant.kSpaceVerticalSmallExtraExtraExtra, bottom: AppConstant.kSpaceVerticalSmallExtraExtraExtra),
      child: Center(
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _StepWidget(
              number: "1",
              title: "Kế hoạch",
              isActive: documentExpanded,
              onClick: () {
                onClick(1);
              },
            ),
            AppConstant.spaceHorizontalSmallExtraExtraExtra,
            AppConstant.spaceHorizontalSmallExtraExtraExtra,
            AppConstant.spaceHorizontalSmallExtraExtraExtra,
            //Spacer(),
            //_DashWidget(),
            //Spacer(),
            _StepWidget(
              onClick: () {
                onClick(2);
              },
              number: "2",
              isActive: inventoryItemExpanded,
              title: "Hàng hóa",
            ),
            /*_DashWidget(),
          _StepWidget(
            onClick: () {
              onClick(3);
            },
            isActive: saveOrderExpanded,
            number: "3",
            title: "Lưu phiếu",
          ),*/
          ],
        ),
      ),
    );
  }
}

class _DashWidget extends StatelessWidget {
  const _DashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 40.w,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: DashLineWidget(
            color: AppColors.grey50,
          ),
        ));
  }
}

class _StepWidget2 extends StatelessWidget {
  const _StepWidget2(
      {Key? key,
        this.number,
        this.title,
        required this.isActive,
        required this.onClick})
      : super(key: key);

  final String? number;
  final String? title;
  final bool isActive;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            InkWellWidget(
              onPress: onClick,
              child: Container(
                width: 44.r,
                height: 44.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: isActive ? AppColors.blue : AppColors.grey300,
                    shape: BoxShape.circle),
                child: Text(
                  number ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            AppConstant.spaceVerticalSmallExtra,
            Text(
              title ?? '',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        )
      ],
    );
  }
}

class _StepWidget extends StatelessWidget {
  const _StepWidget(
      {Key? key,
        this.number,
        this.title,
        required this.isActive,
        required this.onClick})
      : super(key: key);

  final String? number;
  final String? title;
  final bool isActive;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWellWidget(
          onPress: onClick,
          child: Container(
            width: 33.r,
            height: 33.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isActive ? AppColors.blue : AppColors.grey300,
                shape: BoxShape.circle),
            child: Text(
              number ?? '',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ),
        AppConstant.spaceHorizontalSmallExtra,
        Text(
          title ?? '',
          style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 15.sp),
        )
      ],
    );
  }
}

class _ExpandedItem extends StatelessWidget {
  const _ExpandedItem(
      {Key? key,
        required this.childExpanded,
        required this.title,
        required this.isExpanded,
        required this.expandStateChange})
      : super(key: key);

  final Widget childExpanded;
  final String title;
  final bool isExpanded;
  final Function(bool isExpanded) expandStateChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
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
            isExpanded: isExpanded,
            titleColor: isExpanded ? AppColors.blue : AppColors.grey700,
            onChangeValue: () {
              expandStateChange(isExpanded);
            },
          ),
          ExpandedWidget(
            expand: isExpanded,
            child: childExpanded,
          )
        ],
      ),
    );
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

class StoreDropdownWidget extends StatelessWidget {
  const StoreDropdownWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<KiemKhoController>();
    return InkWellWidget(
        onPress: () {
          showViewDialog(
              context,
              FilterWarehouseWidget(
                searchListWarehouse: (String keyword) {
                  return controller.searchWarehouseByKey(keyword);
                },
                onDone: (item) async {
                  Get.back();
                  await controller.setSelectedWarehouse(item);
                },
              ));
        },
        child: Container(
            padding:
            EdgeInsets.only(left: AppConstant.kSpaceHorizontalSmallExtra),
            height: 48,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                shape: BoxShape.rectangle),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 41),
                        child: Text(
                          controller.warehouseSelected == null
                              ? 'Chọn kho hàng'
                              : controller.warehouseSelected?.Ten ?? "",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: AppColors.grey300, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    AppConstant.spaceHorizontalSmall,
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.grey300,
                      size: 30.r,
                    ),
                    AppConstant.spaceHorizontalSmall,
                  ],
                ),
                Container(
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(width: 0.8, color: AppColors.grey50))),
                  padding: const EdgeInsets.only(left: 0, right: 10),
                  child: Icon(Icons.search, color: AppColors.grey300, size: 19.sp,),
                ),
              ],
            )
        ));
  }
}

class PlansDropdownWidget extends StatelessWidget {
  const PlansDropdownWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<KiemKhoController>();
    return InkWellWidget(
        onPress: () {
          if(controller.warehouseSelected == null) {
            showToast("Bạn chưa chọn kho");
            return;
          }
          showViewDialog(
              context,
              FilterPlansWidget(
                searchListPlans: (String keyword) {
                  return controller.searchPlansByKey(keyword);
                },
                onDone: (item) async {
                  Get.back();
                  controller.setSelectedPlan(item);
                  await controller.getListProductsByPlan(controller.warehouseSelected?.Ma ?? "", item.Ma ?? "");
                },
              ));
        },
        child: Container(
            padding:
            EdgeInsets.only(left: AppConstant.kSpaceHorizontalSmallExtra),
            height: 48,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                shape: BoxShape.rectangle),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 41),
                        child: Text(
                          controller.planSelected == null
                              ? 'Chọn kế hoạch'
                              : controller.planSelected?.Ten ?? "",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: AppColors.grey300, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    AppConstant.spaceHorizontalSmall,
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.grey300,
                      size: 30.r,
                    ),
                    AppConstant.spaceHorizontalSmall,
                  ],
                ),
                Container(
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(width: 0.8, color: AppColors.grey50))),
                  padding: const EdgeInsets.only(left: 0, right: 10),
                  child: Icon(Icons.search, color: AppColors.grey300, size: 19.sp,),
                ),
              ],
            )
        ));
  }
}
