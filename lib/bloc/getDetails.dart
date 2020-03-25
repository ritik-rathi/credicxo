import 'package:movies_bloc_task/model/detailsResponse.dart';
import 'package:movies_bloc_task/repository/detailRepo.dart';
import 'package:rxdart/rxdart.dart';

class DetailBloc {
  final DetailRepo _repo = DetailRepo();
  final BehaviorSubject<DetailsResponse> _subject =
      BehaviorSubject<DetailsResponse>();
  final BehaviorSubject<CastResponse> _cast = BehaviorSubject<CastResponse>();
  final BehaviorSubject<GenreResponse> _genre =
      BehaviorSubject<GenreResponse>();

  getDetails(int id) async {
    DetailsResponse response = await _repo.getDetails(id);
    _subject.sink.add(response);
  }

  getcast(int id) async {
    CastResponse response = await _repo.getCast(id);
    _cast.sink.add(response);
  }

  getGenre(int id) async {
    GenreResponse response = (await _repo.getGenre(id)) as GenreResponse;
    _genre.sink.add(response);
  }

  dispose() {
    _subject.sink.add(DetailsResponse(details: [], error: ""));
    _subject.drain();
    _cast.sink.add(CastResponse(cast: [], error: ''));
    _cast.drain();
    _genre.sink.add(GenreResponse(genre: [], error: ''));
    _genre.drain();
  }

  BehaviorSubject<DetailsResponse> get subject => _subject;

  BehaviorSubject<CastResponse> get cast => _cast;

  BehaviorSubject<GenreResponse> get genre => _genre;
}

final detailBloc = DetailBloc();
