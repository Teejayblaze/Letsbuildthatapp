import 'package:flutter/material.dart';
import 'package:you_feed/feed_listing.dart';

void main() => runApp(RootApp());

class RootApp extends StatelessWidget {
  // This widget is the root of your application.
  final url = 'https://api.letsbuildthatapp.com/youtube/home_feed';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue,),
      debugShowCheckedModeBanner: false,
      home: new FeedListing(url: this.url),
    );
  }
}