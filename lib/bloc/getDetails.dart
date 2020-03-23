import 'package:movies_bloc_task/model/detailsResponse.dart';
import 'package:movies_bloc_task/repository/detailRepo.dart';
import 'package:rxdart/rxdart.dart';

class DetailBloc {
  final DetailRepo _repo = DetailRepo();
  final BehaviorSubject<DetailsResponse> _subject =
      BehaviorSubject<DetailsResponse>();

  getDetails(int id) async {
    DetailsResponse response = await _repo.getDetails(id);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.sink.add(DetailsResponse(details: [], error: ""));
    _subject.drain();
  }

  BehaviorSubject<DetailsResponse> get subject => _subject;
}

final detailBloc = DetailBloc();
