import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/model/AllVideoModel.dart';
import 'package:sale_soft/model/VideoModel.dart';

class VideoController extends GetxController with StateMixin<AllVideoModel> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<VideoModel> listTutorVideo = [];
  List<VideoModel> listAdminVideo = [];

  AllVideoModel model = AllVideoModel();

  @override
  void onInit() {
    super.onInit();
    getListVideo();
  }

  getListVideoTutor() async {
    List<VideoModel> response = await HttpUtil()
        .get("${UrlHelper.LIST_VIDEO}/1")
        .then<List<VideoModel>>((value) {
      if (value != null) {
        return Future<List<VideoModel>>.value(VideoModel.listFromJson(value));
      } else {
        return Future<List<VideoModel>>.value(<VideoModel>[]);
      }
    });

    if (response.isNotEmpty) {
      listTutorVideo.clear();
      listTutorVideo.addAll(response);
      refreshController.refreshCompleted();
      change(model..listTutorVideo = listTutorVideo,
          status: RxStatus.success());
    } else {
      refreshController.refreshFailed();
      change(model..listTutorVideo = [], status: RxStatus.empty());
    }
  }

  getListVideoAdmin() async {
    List<VideoModel> response = await HttpUtil()
        .get("${UrlHelper.LIST_VIDEO}/2")
        .then<List<VideoModel>>((value) {
      if (value != null) {
        return Future<List<VideoModel>>.value(VideoModel.listFromJson(value));
      } else {
        return Future<List<VideoModel>>.value(<VideoModel>[]);
      }
    });

    if (response.isNotEmpty) {
      listAdminVideo.clear();
      listAdminVideo.addAll(response);
      refreshController.loadComplete();
      change(model..listAdminVideo = listAdminVideo,
          status: RxStatus.success());
    } else {
      refreshController.loadNoData();
      change(model..listAdminVideo = [], status: RxStatus.empty());
    }
  }

  getListVideo() {
    getListVideoTutor();
    getListVideoAdmin();
  }
}
