import 'package:dio/dio.dart';
import 'package:movies_bloc_task/model/moviesResponse.dart';

class MovieRepo {
  final String apiKey = "95dfe2a8f8b8341fb4e8ac68fce743e5";
  static String mainUrl = "http://api.themoviedb.org/3";
  final Dio _dio = Dio();
  var getMoviesUrl = "$mainUrl/movie/popular";

  Future<MovieResponse> getMovies() async {
    var params = {"api_key": apiKey, "language": "en-US", "page:": 1};
    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception occured: $error stacktrace: $stackTrace');
      return MovieResponse.withError("$error");
    }
  }
}
