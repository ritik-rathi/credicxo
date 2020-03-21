import 'detail.dart';

class DetailsResponse {
  final List<Details> details;
  final String error;

  DetailsResponse(this.details, this.error);

  DetailsResponse.fromJson(Map<String, dynamic> json)
      : details = (json["results"] as List)
            .map((i) => new Details.fromHJson(i))
            .toList(),
        error = "";

  DetailsResponse.withError(String errorValue)
      : details = List(),
        error = errorValue;
}
