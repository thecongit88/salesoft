import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/news_repository.dart';
import 'package:sale_soft/model/news_detail.dart';
import 'package:sale_soft/model/news_model.dart';

class NewsDetailArgument {
  int? id;
  int? type;
  String? title;

  NewsDetailArgument({this.id, this.type, this.title});
}

class NewsDetailController extends GetxController with StateMixin<NewsDetail> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  NewsDetailArgument? argument;

  /// Ds các bài viết liên quan
  var newsSameCategory = <NewsModel>[].obs;

  /// Provider
  late INewsRepository repository = Get.find();

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments;
    fetchNewsDetail();
    fetchSameContent();
  }

  ///
  /// Lấy chi tiết detail
  ///
  void fetchNewsDetail() async {
    if (argument?.id == null) {
      change(null, status: RxStatus.empty());
      return;
    } else {
      change(null, status: RxStatus.loading());
    }

    final result = await repository.getNewsDetail(id: argument!.id!);
    if (result != null) {
      change(result, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
    refreshController.refreshCompleted();
  }

  /// Lấy ds bài viết cùng loại
  void fetchSameContent() async {
    if (argument?.id == null || argument?.type == null) {
      return;
    }
    final result = await repository.getNewsSameCategory(
        type: argument!.type!, id: argument!.id!);
    if (result.isNotEmpty) {
      newsSameCategory.value = result;
    }
  }

  ///
  /// Reload dữ liệu page
  /// [param: id]: Id bài viết
  ///
  void onReloadDataPage(int? id, String? title) {
    if (id != null) {
      argument?.id = id;
      argument?.title = title;
    }
    fetchNewsDetail();
    fetchSameContent();
  }
}
