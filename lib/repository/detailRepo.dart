import 'package:dio/dio.dart';
import 'package:movies_bloc_task/model/detailsResponse.dart';

class DetailRepo {
  final String apiKey = "95dfe2a8f8b8341fb4e8ac68fce743e5";
  static String mainUrl = "http://api.themoviedb.org/3";
  final Dio _dio = Dio();
  //var getMoviesUrl = "$mainUrl/movie/419704/videos";

  Future<DetailsResponse> getDetails(int id) async {
    var params = {"api_key": apiKey, "language": "en-US", "page:": 1};
    try {
      Response response =
          await _dio.get("$mainUrl/movie/$id/videos", queryParameters: params);
      return DetailsResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception occured: $error stacktrace: $stackTrace');
      return DetailsResponse.withError("$error");
    }
  }
}
