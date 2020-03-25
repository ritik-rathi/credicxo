import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:movies_bloc_task/bloc/getDetails.dart';
import 'package:movies_bloc_task/model/detail.dart';
import 'package:movies_bloc_task/model/detailsResponse.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String name, img;
  DetailScreen({this.id, this.img, this.name});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int network = 1;
  @override
  void initState() {
    super.initState();

    //getDetailsFinal();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('connection check -  ${result.toString()}');
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          network = 1;
        });
        print(network);
        //getDetailsFinal();
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
        title: Text(widget.name),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              detailBloc.dispose();
              Navigator.pop(context);
            }),
      ),
      body: network == 1
          ? Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: double.infinity,
                    child: Image(
                        image: NetworkImage(widget.img), fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text('Genre - ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    child: StreamBuilder<GenreResponse>(
                      stream: detailBloc.genre.stream,
                      builder:
                          (context, AsyncSnapshot<GenreResponse> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.error != null &&
                              snapshot.data.error.length > 0) {
                            return _errorWidget(snapshot.data.error);
                          }
                          return _getGenre(snapshot.data);
                        } else if (snapshot.hasError) {
                          return _errorWidget(snapshot.error);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 120,
                    child: StreamBuilder<CastResponse>(
                      stream: detailBloc.cast.stream,
                      builder: (context, AsyncSnapshot<CastResponse> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.error != null &&
                              snapshot.data.error.length > 0) {
                            return _errorWidget(snapshot.data.error);
                          }
                          return _movieDetail(snapshot.data);
                        } else if (snapshot.hasError) {
                          return _errorWidget(snapshot.error);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(child: Text('Oops! Check your internet connection.')),
    );
  }

  Widget _getGenre(GenreResponse data) {
    List<Genre> _genre = data.genre;
    if (_genre.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _genre.length,
        itemBuilder: (context, index) {
          return Text('  - ${_genre[index].genre}',
              style: TextStyle(fontSize: 15));
        },
      );
    }
  }

  Widget _errorWidget(String error) {
    return Center(
      child: Text(error),
    );
  }

  Widget _movieDetail(CastResponse data) {
    List<Cast> _cast = data.cast;
    if (_cast.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: _cast.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      height: 70,
                      width: 70,
                      child: _cast[index].image != null
                          ? Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/original/' +
                                      _cast[index].image),
                            )
                          : Container()),
                ),
                Flexible(child: Text(_cast[index].name))
              ],
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      );
    }
  }
}
