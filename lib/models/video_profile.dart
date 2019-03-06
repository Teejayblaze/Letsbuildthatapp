import 'package:flutter/material.dart';

// Overall Video Profile as given by Youtube
class VideoProfile {
  final User user;
  final List<Video> videos;
  VideoProfile({this.user, @required this.videos}); 

  factory VideoProfile.fromJson(Map<String, dynamic> json) {
    return new VideoProfile(
      user: new User(id: json['user']['id'], name: json['user']['name'], username: json['user']['username']),
      videos: json['videos'].map<Video>((video) => Video.fromJson(video)).toList()
    );
  }
}


// Created our User details model
class User {
  final int id;
  final String name; 
  final String username;

  User({this.id, this.name, this.username});
}

/*
 * Created our Video model type for collection of similar data.
 * Our only single source of truth from our network class
 * 
 */

class Video {
  final int id;
  final String name;
  final String link;
  final String imageUrl;
  final int numberOfViews;

  Video({@required this.id, @required this.name, @required this.link, @required this.imageUrl, @required this.numberOfViews});

  factory Video.fromJson(Map<String, dynamic> json) {
    return new Video(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      imageUrl: json['imageUrl'],
      numberOfViews: json['numberOfViews'],
    );
  }
}


class SingleVideo {

  final int number;
  final String name;
  final String link;
  final String imageUrl;
  final String duration;

  SingleVideo({@required this.number, @required this.name, @required this.link, @required this.imageUrl, @required this.duration});

  factory SingleVideo.fromJson(Map<String, dynamic> jsonObj) {
    return new SingleVideo(
      number: jsonObj['number'],
      name: jsonObj['name'],
      link: jsonObj['link'],
      imageUrl: jsonObj['imageUrl'],
      duration: jsonObj['duration'],
    );
  }
}