import 'package:dio/dio.dart';
import 'package:movies_bloc_task/model/searchResponse.dart';

class SearchRepo {
  final String apiKey = "95dfe2a8f8b8341fb4e8ac68fce743e5";
  static String mainUrl = "http://api.themoviedb.org/3";
  final Dio _dio = Dio();
  //var getMoviesUrl = "$mainUrl/movie/419704/videos";

  Future<SearchResponse> searchMovie(String movie) async {
    var params = {"api_key": apiKey, "language": "en-US", "page:": 2};
    try {
      Response response = await _dio.get(
          "$mainUrl/search/movie?query=$movie",
          queryParameters: params);
      return SearchResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception occured: $error stacktrace: $stackTrace');
      return SearchResponse.withError("$error");
    }
  }
}
