import 'package:flutter/material.dart';
import 'package:movies_bloc_task/bloc/getDetails.dart';
import 'package:movies_bloc_task/bloc/getMovies.dart';
import 'package:movies_bloc_task/bloc/searchMovie.dart';
import 'package:movies_bloc_task/model/movies.dart';
import 'package:movies_bloc_task/model/moviesResponse.dart';
import 'package:movies_bloc_task/ui/detailScreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:movies_bloc_task/ui/searchScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = new TextEditingController();
  int network;
  int search = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //moviesBloc.getMovies();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('connection check -  ${result.toString()}');
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          network = 1;
        });
        print(network);
        moviesBloc.getMovies();
      } else {
        setState(() {
          network = 0;
        });
        print(network);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: search == 0
            ? Text('Movies App')
            : Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Colors.white)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration.collapsed(
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchScreen(movie: _controller.text)));
                            print(_controller.text);
                            //_controller.clear();
                          },
                        ),
                      ],
                    ))),
        actions: <Widget>[
          search == 0
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      search = 1;
                    });
                  })
              : FlatButton(
                  onPressed: () {
                    setState(() {
                      search = 0;
                    });
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ))
        ],
      ),
      body: network == 1
          ? StreamBuilder<MovieResponse>(
              stream: moviesBloc.subject.stream,
              builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0) {
                    return _errorWidget(snapshot.data.error);
                  }
                  return _movieList(snapshot.data);
                } else if (snapshot.hasError) {
                  return _errorWidget(snapshot.error);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : Center(child: Text('Oops! Check your internet connection.')),
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
          int id = movies[index].id;
          String name = movies[index].title;
          String img =
              "https://image.tmdb.org/t/p/original/" + movies[index].poster;
          return GestureDetector(
            onTap: () async {
              //   print('hahahaha');
              //  await detailBloc.getDetails(movies[index].id);
              //   print('Details received');

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(id: id, name: name, img: img)));
              await detailBloc.getDetails(id);
              await detailBloc.getcast(id);
              await detailBloc.getGenre(id);
              print(id);
              print('details received');
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                color: Colors.grey[400],
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image(
                            image: NetworkImage(img),
                            fit: BoxFit.cover,
                          ),
                        )),
                    Flexible(
                        child: Text(
                      name,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
