import 'package:sale_soft/api/provider/news_provider.dart';
import 'package:sale_soft/model/news_detail.dart';
import 'package:sale_soft/model/news_model.dart';
import 'package:sale_soft/model/question_model.dart';

abstract class INewsRepository {
  /// Ds bài viết software và marketing
  Future<List<NewsModel>> getNews({required int type, required int pageIndex});

  /// Ds câu hỏi
  Future<List<QuestionModel>> getQuestions({required int pageIndex});

  /// Chi tiết tin túc
  Future<NewsDetail?> getNewsDetail({required int id});

  /// Lấy ds bài viết cùng thể loại
  Future<List<NewsModel>> getNewsSameCategory(
      {required int type, required int id});
}

class NewsRepository implements INewsRepository {
  final INewsProvider provider;

  NewsRepository({
    required this.provider,
  });

  @override
  Future<List<NewsModel>> getNews(
      {required int type, required int pageIndex}) async {
    final response = provider.getNews(type: type, pageIndex: pageIndex);

    return response.then<List<NewsModel>>((value) {
      if (value != null) {
        return Future<List<NewsModel>>.value(NewsModel.listFromJson(value));
      } else {
        return Future<List<NewsModel>>.value(<NewsModel>[]);
      }
    }).catchError((onError) {
      return Future<List<NewsModel>>.value(<NewsModel>[]);
    });
  }

  @override
  Future<List<QuestionModel>> getQuestions({required int pageIndex}) async {
    final response = provider.getQuestions(pageIndex: pageIndex);

    return response.then<List<QuestionModel>>((value) {
      if (value != null) {
        return Future<List<QuestionModel>>.value(
            QuestionModel.listFromJson(value));
      } else {
        return Future<List<QuestionModel>>.value(<QuestionModel>[]);
      }
    }).catchError((onError) {
      return Future<List<QuestionModel>>.value(<QuestionModel>[]);
    });
  }

  @override
  Future<NewsDetail?> getNewsDetail({required int id}) {
    final response = provider.getNewsDetail(id: id);

    return response.then<NewsDetail?>((value) {
      if (value != null) {
        return Future<NewsDetail>.value(NewsDetail.fromMap(value));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<NewsModel>> getNewsSameCategory(
      {required int type, required int id}) {
    final response = provider.getNewsSameCategory(type: type, id: id);

    return response.then<List<NewsModel>>((value) {
      if (value != null) {
        return Future<List<NewsModel>>.value(NewsModel.listFromJson(value));
      } else {
        return Future<List<NewsModel>>.value(<NewsModel>[]);
      }
    }).catchError((onError) {
      return Future<List<NewsModel>>.value(<NewsModel>[]);
    });
  }
}
