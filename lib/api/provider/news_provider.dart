import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/url_helper.dart';

abstract class INewsProvider {
  Future<dynamic> getNews({required int type, required int pageIndex});

  Future<dynamic> getQuestions({required int pageIndex});

  Future<dynamic> getNewsDetail({required int id});

  Future<dynamic> getNewsSameCategory({required int type, required int id});
}

class NewsProviderAPI implements INewsProvider {
  @override
  Future<dynamic> getNews({required int type, required int pageIndex}) async {
    final urlEndPoint = "${UrlHelper.LIST_NEWS}/$type/$pageIndex";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getQuestions({required int pageIndex}) async {
    final urlEndPoint = "${UrlHelper.LIST_QUESTION}/$pageIndex";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getNewsDetail({required int id}) async {
    final urlEndPoint = "${UrlHelper.NEWS_DETAIL}/$id";
    return await HttpUtil().get(urlEndPoint);
  }

  @override
  Future getNewsSameCategory({required int type, required int id}) async {
    final urlEndPoint = "${UrlHelper.SAME_NEWS}/$type/$id";
    return await HttpUtil().get(urlEndPoint);
  }
}
