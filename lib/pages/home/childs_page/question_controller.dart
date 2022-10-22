import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/news_repository.dart';
import 'package:sale_soft/model/question_model.dart';

class QuestionController extends GetxController
    with StateMixin<List<QuestionModel>> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  // content display
  List<QuestionModel> contentsDisplay = [];
  // Index LoadMore
  int _pageIndex = 1;

  /// Provider
  final INewsRepository repository = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchListContent();
  }

  /// Lấy ds Question
  void fetchListContent({bool isLoadMore = false}) {
    if (!isLoadMore) {
      change(null, status: RxStatus.loading());
      _pageIndex = 1;
      contentsDisplay = [];
      refreshController.resetNoData();
    }

    repository.getQuestions(pageIndex: _pageIndex).then((result) {
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
    }, onError: (err) {
      change(null, status: RxStatus.error());
    });
  }
}
