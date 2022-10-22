import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/news_repository.dart';
import 'package:sale_soft/model/news_model.dart';

class MarketingController extends GetxController
    with StateMixin<List<NewsModel>> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  // content display
  List<NewsModel> contentsDisplay = [];
  // Index LoadMore
  int _pageIndex = 1;
  int type = 2;

  /// Provider
  late INewsRepository repository;

  @override
  void onInit() {
    super.onInit();
    repository = Get.find();
    fetchListContent();
  }

  /// Lấy ds bài viết
  void fetchListContent({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      change(null, status: RxStatus.loading());
      _pageIndex = 1;
      contentsDisplay = [];
      refreshController.resetNoData();
    }

    final result = await repository.getNews(type: type, pageIndex: _pageIndex);
    if (result.isNotEmpty == true) {
      contentsDisplay.addAll(result);
      refreshController.loadComplete();
      _pageIndex += 1;
    } else {
      refreshController.loadNoData();
    }
    if (contentsDisplay.isEmpty) {
      change(contentsDisplay, status: RxStatus.empty());
    } else {
      change(contentsDisplay, status: RxStatus.success());
    }
  }
}
