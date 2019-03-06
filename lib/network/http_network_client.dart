import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// A singleton network class that request for a resource.
class HttpNetworkClient {
  final url;

  HttpNetworkClient({@required this.url});

  Future getResource() async {
    return await http.get(this.url);
  }
}