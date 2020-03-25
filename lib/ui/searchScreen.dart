import 'package:flutter/material.dart';
import 'package:movies_bloc_task/bloc/getDetails.dart';
import 'package:movies_bloc_task/bloc/searchMovie.dart';
import 'package:movies_bloc_task/model/search.dart';
import 'package:movies_bloc_task/model/searchResponse.dart';

import 'detailScreen.dart';

class SearchScreen extends StatefulWidget {
  final String movie;

  SearchScreen({this.movie});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.movie);
    searchBloc.searchMovie(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('You searched'),
      ),
      body: StreamBuilder<SearchResponse>(
        stream: searchBloc.subject.stream,
        builder: (context, AsyncSnapshot<SearchResponse> snapshot) {
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

  Widget _movieList(SearchResponse data) {
    List<Search> search = data.searchMovie;
    if (search.length == 0) {
      return Center(
        child: Text('No movies to show!'),
      );
    } else {
      return ListView.builder(
        itemCount: search.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              //   print('hahahaha');
              //  await detailBloc.getDetails(movies[index].id);
              //   print('Details received');

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            id: search[index].id,
                            name: search[index].title,
                            img: "https://image.tmdb.org/t/p/original/" +
                                search[index].poster,
                          )));
              await detailBloc.getDetails(search[index].id);
              await detailBloc.getcast(search[index].id);
              print(search[index].id);
              print('details received');
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
                                search[index].poster),
                        fit: BoxFit.cover,
                      ),
                    )),
                Flexible(
                    child:
                        Text(search[index].title, overflow: TextOverflow.fade))
              ],
            ),
          );
        },
      );
    }
  }
}
