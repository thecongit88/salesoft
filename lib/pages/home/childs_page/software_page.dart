import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/pages/home/childs_page/software_controller.dart';
import 'package:sale_soft/pages/home/childs_page/widgets/news_item_widget.dart';
import 'package:sale_soft/pages/home/news_detail/news_detail_controller.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';

class SoftwarePage extends StatefulWidget {
  const SoftwarePage({Key? key}) : super(key: key);

  @override
  _SoftwarePageState createState() => _SoftwarePageState();
}

class _SoftwarePageState extends State<SoftwarePage>
    with AutomaticKeepAliveClientMixin<SoftwarePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.put(SoftwareController());
    return controller.obx((contentDisplay) {
      return SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () => {controller.fetchListContent()},
        onLoading: () => {controller.fetchListContent(isLoadMore: true)},
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: AppConstant.kSpaceVerticalLarge),
          itemBuilder: (context, index) {
            return NewsItemView(
              link: contentDisplay![index].LinkWebsite,
              imageUrl: contentDisplay[index].image,
              title: contentDisplay[index].title,
              summay: contentDisplay[index].summary,
              date: contentDisplay[index].date,
              onTap: () => {
                Get.toNamed(ERouter.newsDetailPage.name,
                    arguments: NewsDetailArgument(
                        title: contentDisplay[index].title,
                        type: controller.type,
                        id: contentDisplay[index].id))
              },
            );
          },
          itemCount: contentDisplay?.length ?? 0,
        ),
      );
    },
        onEmpty: EmptyDataWidget(
          onReloadData: () => {controller.fetchListContent()},
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
