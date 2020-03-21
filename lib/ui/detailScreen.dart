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
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   //detailBloc.getDetails(widget.id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: StreamBuilder<DetailsResponse>(
        stream: detailBloc.subject.stream,
        builder: (context, AsyncSnapshot<DetailsResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _errorWidget(snapshot.data.error);
            }
            return _movieDetail(snapshot.data);
          } else if (snapshot.hasError) {
            return _errorWidget(snapshot.error);
          } else {
            return Center(child: Text('Loading...'));
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

  Widget _movieDetail(DetailsResponse data) {
    List<Details> _details = data.details;
    if (_details.length == 0) {
      return Center(child: Text('No Detail available'));
    } else {
      return Center(
        child: Text(
            "${_details[0].did} || ${_details[0].name} || ${_details[0].site}"),
      );
    }
  }
}
