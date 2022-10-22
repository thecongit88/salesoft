import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/NotificationModel.dart';
import 'package:sale_soft/pages/notification/notification_controller.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NotificationState();
  }
}

class NotificationState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    // super.build(context);

    final controller = Get.put(NotificationController());
    return controller.obx((listNotification) {
      return SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: () => {controller.getListNotification()},
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: AppConstant.kSpaceVerticalLarge),
          itemCount: listNotification?.length ?? 0,
          itemBuilder: (context, index) {
            return buildNotificationItem(listNotification![index], index);
          },
        ),
      );
    },
        onEmpty: EmptyDataWidget(
          onReloadData: () => {controller.getListNotification()},
        ));
  }

  Widget buildNotificationItem(NotificationModel notification, int index) {
    NotificationController controller = Get.find<NotificationController>();
    return InkWellWidget(
      onPress: () {
        controller.markItemAsRead(notification);

        showViewDialog(
            context,
            SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: getColor(index),
                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                        ),
                        width: 0.1.sw,
                        height: 0.1.sw,
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                        // child: Align(
                        //   alignment: Alignment.bottomRight,
                        //   child: IconButton(
                        //       onPressed: () {
                        //         Get.back();
                        //       },
                        //       icon: Icon(
                        //         Icons.close,
                        //         color: AppColors.grey,
                        //       )),
                        // ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Text(
                      notification.Content ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification.Status == 0 ? AppColors.grey50 : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: AppColors.grey50, width: 0.5),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: getColor(index),
                borderRadius: BorderRadius.all(Radius.circular(9.0)),
              ),
              width: 0.1.sw,
              height: 0.1.sw,
              child: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  notification.Title ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(getDate(notification.Date1 ?? ""),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: AppColors.grey,
                        fontSize: 10))
              ],
            )),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Color getColor(int index) {
    var controller = Get.find<NotificationController>();
    int x = index - ((index ~/ 6) * 6);

    return controller.listColor[x];
  }

  String getDate(String s) {
    var date = DateTimeHelper.stringToDate(
        dateStr: s, parten: "yyyy-MM-dd'T'hh:mm:ss");
    debugPrint(date.toString());

    String time =
        DateTimeHelper.dateToStringFormat(date: date, parten: "hh:mm") ?? "";
    String day =
        DateTimeHelper.dateToStringFormat(date: date, parten: "dd/mm/yy") ?? "";

    return "Ngày " + day + " lúc " + time;
  }
}
