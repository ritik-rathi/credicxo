import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:movies_bloc_task/bloc/getDetails.dart';
import 'package:movies_bloc_task/model/detail.dart';
import 'package:movies_bloc_task/model/detailsResponse.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  DetailScreen({this.id});
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail Screen'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                detailBloc.dispose();
                Navigator.pop(context);
              }),
        ),
        body: network == 1
            ? StreamBuilder<DetailsResponse>(
                stream: detailBloc.subject.stream,
                builder: (context, AsyncSnapshot<DetailsResponse> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.error != null &&
                        snapshot.data.error.length > 0) {
                      return _errorWidget(snapshot.data.error);
                    }
                    return _movieDetail(snapshot.data);
                  } else if (snapshot.hasError) {
                    return _errorWidget(snapshot.error);
                  } else {
                    return Center(child: Text('Loading...'));
                  }
                },
              )
            : Center(child: Text('Oops! Check your internet connection.')),
      ),
    );
  }

  Widget _errorWidget(String error) {
    return Center(
      child: Text(error),
    );
  }

  Widget _movieDetail(DetailsResponse data) {
    List<Details> _details = data.details;
    if (_details.length == 0) {
      return Center(child: Text('Loading...'));
    } else {
      return Center(
        child: Text(
            "${_details[0].did} || ${_details[0].name} || ${_details[0].site}"),
      );
    }
  }
}
