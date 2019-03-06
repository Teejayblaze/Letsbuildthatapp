import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:you_feed/network/http_network_client.dart';
import 'package:you_feed/models/video_profile.dart';
import 'package:you_feed/single_feed.dart';


class FeedListing extends StatelessWidget {
  final url;
  FeedListing({@required this.url});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Real World App Bar'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => null,
          ),
        ],
      ),
      body: new Container( // Let's display our records when it's available with the help of FutureBuilder
        child: FutureBuilder<List<Video>>(
          future: this.getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) return new Center(child: Text("${snapshot.error}"),);
              else if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) => new FeedListingLayout(feed: snapshot.data[index],),
                  );
                }
              }
            }
            return new Center( child: new CircularProgressIndicator() );
          },
        ),
      ),
    );
  }

  Future <List<Video>> getData() async {
    final HttpNetworkClient hnc = new HttpNetworkClient(url: this.url);
    final response = await hnc.getResource();
    if (response.statusCode == 200) return VideoProfile.fromJson(json.decode(response.body)).videos;
    else return [];
  }
}


/**
 * 
 * Let's build our layout in a different class to decouple component and separate 
 * concerns.
 * 
 */

class FeedListingLayout extends StatelessWidget {

  final feed;
  FeedListingLayout({@required this.feed});

  @override
  Widget build(BuildContext context){
    return new Material(
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Card(
          elevation: 16.0,
          child: InkWell(
            highlightColor: Colors.teal[50],
            splashColor: Colors.teal,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new SingleFeed(id: feed.id, name: this.feed.name,))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  // Large Image
                  Flexible(
                    child: Image.network(this.feed.imageUrl),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      // Circular Image
                      new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(this.feed.imageUrl),
                      ),

                      // A little padding for breathing of component
                      Padding(padding: EdgeInsets.only(right: 5.0)),

                      // 
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(this.feed.name, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("Number of views: ${this.feed.numberOfViews}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ),
              ],
            ),
          ),
        ) 
      ),
    );
  }
}