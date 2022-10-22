import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/pages/home/childs_page/marketing_controller.dart';
import 'package:sale_soft/pages/home/childs_page/widgets/news_item_widget.dart';
import 'package:sale_soft/pages/home/news_detail/news_detail_controller.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';

///
/// Màn hình thông tin Marketing
///
class MarketingPage extends StatefulWidget {
  const MarketingPage({Key? key}) : super(key: key);

  @override
  _MarketingPageState createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage>
    with AutomaticKeepAliveClientMixin<MarketingPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final MarketingController controller = Get.put(MarketingController());
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
