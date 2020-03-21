import 'package:flutter/material.dart';
import 'package:movies_bloc_task/bloc/getDetails.dart';
import 'package:movies_bloc_task/bloc/getMovies.dart';
import 'package:movies_bloc_task/model/movies.dart';
import 'package:movies_bloc_task/model/moviesResponse.dart';
import 'package:movies_bloc_task/ui/detailScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moviesBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies App'),
      ),
      body: StreamBuilder<MovieResponse>(
        stream: moviesBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _errorWidget(snapshot.data.error);
            }
            return _movieList(snapshot.data);
          } else if (snapshot.hasError) {
            return _errorWidget(snapshot.error);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _errorWidget(String error) {
    return Center(
      child: Text(error),
    );
  }

  Widget _movieList(MovieResponse data) {
    List<Movies> movies = data.movies;
    if (movies.length == 0) {
      return Center(
        child: Text('No movies to show!'),
      );
    } else {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              detailBloc.getDetails(movies[index].id);
              print('Details received');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(id: movies[index].id)));
            },
            child: Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Image(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/original/" +
                                movies[index].poster),
                        fit: BoxFit.cover,
                      ),
                    )),
                Flexible(
                    child:
                        Text(movies[index].title, overflow: TextOverflow.fade))
              ],
            ),
          );
        },
      );
    }
  }
}
