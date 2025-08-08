import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traxes/bloc/feature/search/search.state.dart';
import 'package:traxes/constant/env/config.url.dart';
import 'package:traxes/model/search/search.model.dart';

class SearchBloc extends Cubit<SearchState> {
  SearchBloc() : super(SearchLoading());

  void search(keys) async {
    final dio = Dio();
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));
    var baseUrl = url;

    Map<String, dynamic> dataSearch = ({"keys": keys});
    try {
      final response = await dio.post("$baseUrl/user/customerbysearch",
          data: dataSearch,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
              headers: {"Content-Type": "application/json"}));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = SearchModel.fromJson(response.data).data;
        emit(SearchLoaded(resbody!));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
