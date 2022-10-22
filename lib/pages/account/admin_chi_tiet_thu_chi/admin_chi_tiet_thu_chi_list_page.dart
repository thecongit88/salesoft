import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/castflow_model.dart';
import 'package:sale_soft/pages/account/admin_chi_tiet_thu_chi/admin_chi_tiet_thu_chi_list_controller.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';

///
/// Chi tiết khách hàng
///
class AdminChiTietThuChiPage extends StatelessWidget {
  const AdminChiTietThuChiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminChiTietThuChiController controller = Get.find();
    print("test here");
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButtonWidget(),
          backgroundColor: AppColors.blue,
          centerTitle: false,
          title: TitleAppBarWidget(
            title: 'Chi tiết quỹ',
          ),
        ),
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.deepOrangeAccent,
                title: PreferredSize(
                  preferredSize: Size.fromHeight(0.0),
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.white,
                    tabs: [
                      Tab(text: "NHÓM 1: ĐẦU KỲ"),
                      Tab(text: "NHÓM 2: PHÁT SINH"),
                      Tab(text: "NHÓM 3: CUỐI KỲ"),
                    ],
                    indicatorColor: Colors.white,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    onTap: (index) {},
                  ),
                )
              ),
              body: controller.obx((data) {
                return TabBarView(
                    children: [
                      _ListItemExtraWidget(type: "1. Đầu kỳ", title: "Nhóm 1: Đầu kỳ", data: data),
                      _ListItemExtraWidget(type: "2. Phát sinh", title: "Nhóm 2: Phát sinh", data: data),
                      _ListItemExtraWidget(type: "3. Cuối kỳ", title: "Nhóm 3: Cuối kỳ", data: data),
                    ]
                );
              }, onEmpty: EmptyDataWidget(
                onReloadData: () {
                  controller.fetchCashflow();
                },
              )),
            )
        ),
    );
  }
}

class _ListItemExtraWidget extends StatelessWidget {
  final String type;
  final String title;
  final List<CashFlowModel>? data;
  const _ListItemExtraWidget({
    Key? key,
    required this.type,
    required this.title,
    this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminChiTietThuChiController controller = Get.find();
    final TextStyle tblTitle = TextStyle(fontSize: 12.sp, color: AppColors.grey, height: 1.3);
    final TextStyle tblNumber = TextStyle(fontSize: 12.sp, color: AppColors.grey);
    final TextStyle tblHeader = TextStyle(fontSize: 12.sp, color: AppColors.blue);
    final TextStyle tblSummaryHeader = TextStyle(fontSize: 12.sp, color: AppColors.blue);
    final List<TableRow> lstRowHeader = [], lstRow = [];
    final EdgeInsetsGeometry padding =  EdgeInsets.only(top: 8.sp, bottom: 8.sp, left: 5.sp, right: 5.sp);

    //header
    lstRowHeader.add(TableRow(children: [
      Container(
        height: 50.sp,
        color: AppColors.blue50,
        alignment: Alignment.center,
        padding: padding,
        child: Text('Khoản mục', style: tblHeader),
      ),
      Container(
        height: 50.sp,
        color: AppColors.blue50,
        alignment: Alignment.center,
        padding: padding,
        child: Text('Doanh thu (đ)', style: tblHeader),
      ),
      Container(
        height: 50.sp,
        color: AppColors.blue50,
        alignment: Alignment.center,
        padding: padding,
        child: Text('Chi phí (đ)', style: tblHeader),
      ),
      Container(
        height: 50.sp,
        color: AppColors.blue50,
        alignment: Alignment.center,
        padding: padding,
        child: Text('Chênh lệch (đ)', style: tblHeader),
      ),
    ]));

    //item list
    List<CashFlowModel>? list = data?.where((element) => element.nhom!.toUpperCase() == type.toUpperCase()).toList();
    int n = list?.length ?? 0;
    double tongDoanhThu = 0, tongChiPhi = 0, tongChenhLech = 0, _cellHeight = 55.sp;
    for(int i = 0; i < n; i++) {
      CashFlowModel item = data![i];
      tongDoanhThu += item.doanhThu;
      tongChiPhi += item.chiPhi;
      tongChenhLech += item.chenhLech;
      lstRow.add(TableRow(children :[
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            color: i%2!=0 ? AppColors.blue50 : Colors.transparent,
            alignment: Alignment.center,
            height: _cellHeight,
            padding: padding,
            child: Text('${item.ten}', style: tblTitle),
          ),
        ),

        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            height: _cellHeight,
            color: i%2!=0 ? AppColors.blue50 : Colors.transparent,
            alignment: Alignment.center,
            padding: padding,
            child: Text('${formatCurrency(item.doanhThu)}', style: tblNumber),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            color: i%2!=0 ? AppColors.blue50 : Colors.transparent,
            alignment: Alignment.center,
            height: _cellHeight,
            padding: padding,
            child: Text('${formatCurrency(item.chiPhi)}', style: tblNumber),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            color: i%2!=0 ? AppColors.blue50 : Colors.transparent,
            alignment: Alignment.center,
            height: _cellHeight,
            padding: padding,
            child: Text('${formatCurrency(item.chenhLech)}', style: tblNumber),
          ),
        ),
      ]));
    }

    //summary
    lstRowHeader.add(TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          height: 50.sp,
          color: AppColors.grey60,
          alignment: Alignment.center,
          padding: padding,
          child: Text('Tổng', style: tblSummaryHeader),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          height: 50.sp,
          color: AppColors.grey60,
          alignment: Alignment.center,
          padding: padding,
          child: Text('${formatCurrency(tongDoanhThu)}', style: tblSummaryHeader),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          height: 50.sp,
          color: AppColors.grey60,
          alignment: Alignment.center,
          padding: padding,
          child: Text('${formatCurrency(tongChiPhi)}', style: tblSummaryHeader),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          height: 50.sp,
          color: AppColors.grey60,
          alignment: Alignment.center,
          padding: padding,
          child: Text('${formatCurrency(tongChenhLech)}', style: tblSummaryHeader),
        ),
      ),
    ]));

    return Column(
      children: [
        Table(
            columnWidths: {
              0: FlexColumnWidth(3.5),
              1: FlexColumnWidth(2.5),
              2: FlexColumnWidth(2.5),
              3: FlexColumnWidth(2.5),
            },
            border: TableBorder.all(
                color: AppColors.blue50
            ), // Allows to add a border decoration around your table
            children: lstRowHeader
        ),
        Container(
          height: MediaQuery.of(context).size.height - 280,
          child: SingleChildScrollView(
            child: Table(
                columnWidths: {
                  0: FlexColumnWidth(3.5),
                  1: FlexColumnWidth(2.5),
                  2: FlexColumnWidth(2.5),
                  3: FlexColumnWidth(2.5),
                },
                border: TableBorder.all(
                    color: AppColors.blue50
                ), // Allows to add a border decoration around your table
                children: lstRow
            ),
          ),
        )
      ],
    );
  }
}

Widget buildHeader() {
  return SizedBox(
    height: 35,
    child: Row(
      children: [
        verticalLine(),
        Expanded(
            flex: 4,
            child: Column(
              children: [
                horirontalLine(),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      height: 35,
                      color: AppColors.blue50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Doanh thu",
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
            flex: 4,
            child: Column(
              children: [
                horirontalLine(),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      height: 35,
                      color: AppColors.blue50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Chi phí",
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
                      color: AppColors.blue50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Chênh lệch",
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
    color: AppColors.blue50,
  );
}

Container horirontalLine() {
  return Container(
    height: 1,
    color: AppColors.blue50,
  );
}

Widget buildItem() {
  return SizedBox(
    height: 35,
    child: Row(
      children: [
        verticalLine(),
        Expanded(
            flex: 4,
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
                          Text("1000,000",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blue
                            ),
                          ),
                        ],
                      )),
                ),
                horirontalLine()
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("2000,000",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.red
                            ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("3000,000",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.notifi_color_6
                            ),
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
