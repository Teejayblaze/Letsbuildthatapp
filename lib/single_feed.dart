import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:you_feed/models/video_profile.dart';
import 'package:you_feed/network/http_network_client.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SingleFeed extends StatelessWidget {
  
  final url = 'https://api.letsbuildthatapp.com/youtube/course_detail';
  final int id;
  final String name;
  SingleFeed({@required this.id, @required this.name});

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title: Text("${this.name}", overflow: TextOverflow.ellipsis,),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SingleVideo>>(
        future: this.getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if ( snapshot.connectionState == ConnectionState.done ) {
            if ( snapshot.hasError ) return Center(child: Text("${snapshot.error}"),);
            else if ( snapshot.hasData ) {
              if ( snapshot.data != null ) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: new StaggeredGridView.count(
                    crossAxisCount: 4,
                    padding: EdgeInsets.all(1.0),
                    children: snapshot.data.map<Widget>((vid) => BuildStaggeredLayout(video: vid,)).toList(),
                    staggeredTiles: snapshot.data.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                );
              }
            }
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }

  Future<List<SingleVideo>> getData() async {
    final HttpNetworkClient hnc = new HttpNetworkClient(url: this.url + '?id=' + this.id.toString());
    final response = await hnc.getResource();
    if (response.statusCode == 200) return json.decode(response.body).map<SingleVideo>((vid) => SingleVideo.fromJson(vid)).toList();
    else return [];
  }
}

class BuildStaggeredLayout extends StatelessWidget {

  final video;
  BuildStaggeredLayout({@required this.video});

  @override
  Widget build(BuildContext context){
    return Card(
      semanticContainer: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Container(
        height: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(this.video.imageUrl),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child:Text(this.video.name),
            ),
          ],
        ),
      ), 
    );
  }
}