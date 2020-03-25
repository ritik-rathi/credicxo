import 'package:movies_bloc_task/model/searchResponse.dart';
import 'package:movies_bloc_task/repository/searchRepo.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final SearchRepo _repo = SearchRepo();
  final BehaviorSubject<SearchResponse> _subject =
      BehaviorSubject<SearchResponse>();

  searchMovie(String movie) async {
    SearchResponse response = await _repo.searchMovie(movie);
    _subject.sink.add(response);
  }

  dispose() {
    
    _subject.drain();
  }

  BehaviorSubject<SearchResponse> get subject => _subject;
}

final searchBloc = SearchBloc();
