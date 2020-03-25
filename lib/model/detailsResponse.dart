import 'detail.dart';

class DetailsResponse {
  final List<Details> details;
  final String error;

  DetailsResponse({this.details, this.error});

  DetailsResponse.fromJson(Map<String, dynamic> json)
      : details = (json["results"] as List)
            .map((i) => new Details.fromHJson(i))
            .toList(),
        error = "";

  DetailsResponse.withError(String errorValue)
      : details = List(),
        error = errorValue;
}

class CastResponse {
  final List<Cast> cast;
  final String error;

  CastResponse({this.cast, this.error});

  CastResponse.fromJson(Map<String, dynamic> json)
      : cast = (json["cast"] as List).map((i) => new Cast.fromJson(i)).toList(),
        error = "";

  CastResponse.withError(String errorValue)
      : cast = List(),
        error = errorValue;
}

class GenreResponse {
  final List<Genre> genre;
  final String error;

  GenreResponse({this.genre, this.error});

  GenreResponse.fromJson(Map<String, dynamic> json)
      : genre =
            (json["genres"] as List).map((i) => new Genre.fromJson(i)).toList(),
        error = "";

  GenreResponse.withError(String errorValue)
      : genre = List(),
        error = errorValue;
}
