import 'package:movies_bloc_task/model/search.dart';

class SearchResponse {
  final List<Search> searchMovie;
  final String error;

  SearchResponse(this.searchMovie, this.error);

  SearchResponse.fromJson(Map<String, dynamic> json)
      : searchMovie = (json["results"] as List)
            .map((i) => new Search.fromJson(i))
            .toList(),
        error = "";

  SearchResponse.withError(String errorValue)
      : searchMovie = List(),
        error = errorValue;
}
