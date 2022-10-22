import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/instance_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/news_model.dart';
import 'package:sale_soft/pages/home/childs_page/widgets/news_item_widget.dart';
import 'package:sale_soft/pages/home/news_detail/news_detail_controller.dart';
import 'package:get/get.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewsDetailController controller = Get.find();
    return Scaffold(
        appBar: AppBar(
          title: controller.obx((contentDisplay) {
              return Text(
                controller.argument?.title ?? "",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
              );
            },
            onLoading: SizedBox(height: 0,)
          )
        ),
        body: controller.obx((contentDisplay) {
          return SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: () => controller.fetchNewsDetail(),
            child: ListView(
              padding: EdgeInsets.only(bottom: AppConstant.kSpaceVerticalLarge),
              children: [
                NewsItemView(
                  link: contentDisplay?.LinkWebsite,
                  title: contentDisplay?.title ?? "",
                  imageUrl: contentDisplay?.image,
                  date: contentDisplay?.date,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                      vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
                  child: HtmlWidget(
                    (contentDisplay?.content ?? '')
                    // .replaceAll("&height=600&width=600 ", "")
                    ,
                    textStyle: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
                _OtherNewsWidget(),
                AppConstant.spaceVerticalSafeArea
              ],
            ),
          );
        },
            onEmpty: EmptyDataWidget(
              onReloadData: () => controller.fetchNewsDetail(),
            ))
    );
  }
}

class _OtherNewsWidget extends StatelessWidget {
  const _OtherNewsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewsDetailController controller = Get.find();

    return Obx(() {
      if (controller.newsSameCategory.value.isNotEmpty) {
        return Container(
          height: 0.4.sh,
          padding: EdgeInsets.only(
              top: AppConstant.kSpaceVerticalSmallExtraExtraExtra,
              left: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
              right: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Các tin liên quan',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final NewsModel item = controller.newsSameCategory[index];
                    return _NewsSameCategoryWidget(
                      item: item,
                      onPress: () {
                        controller.onReloadDataPage(item.id, item.title);
                      },
                    );
                  },
                  itemCount: controller.newsSameCategory.length,
                ),
              )
            ],
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}

class _NewsSameCategoryWidget extends StatelessWidget {
  const _NewsSameCategoryWidget({
    Key? key,
    required this.item,
    this.onPress,
  }) : super(key: key);

  final NewsModel item;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(right: AppConstant.kSpaceHorizontalSmallExtraExtra),
      width: 168.w,
      child: InkWellWidget(
        onPress: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstant.spaceVerticalSmallMedium,
            Image.network(item.image ?? ''),
            AppConstant.spaceVerticalSmallMedium,
            Text(
              "Ngày đăng: ${item.getDateDisplay()}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontSize: 10.sp, color: AppColors.grey450),
            ),
            AppConstant.spaceVerticalSmall,
            Text(
              item.title ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: AppColors.grey),
            )
          ],
        ),
      ),
    );
  }
}
