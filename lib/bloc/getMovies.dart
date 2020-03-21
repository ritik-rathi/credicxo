import 'package:movies_bloc_task/model/moviesResponse.dart';
import 'package:movies_bloc_task/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc {
  final MovieRepo _repo = MovieRepo();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMovies() async {
    MovieResponse response = await _repo.getMovies();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final moviesBloc = MoviesBloc();
