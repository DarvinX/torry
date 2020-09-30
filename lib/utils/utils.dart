import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Torrent {
  final String id;
  final String name;
  final String hash;
  final String leechers;
  final String seeders;
  final String size;

  Torrent(
      {this.id, this.name, this.hash, this.leechers, this.seeders, this.size});

  factory Torrent.fromJson(Map<String, dynamic> json) {
    return Torrent(
      id: json['id'] as String,
      name: json['name'] as String,
      hash: json['hash'] as String,
      leechers: json['leechers'] as String,
      seeders: json['seeders'] as String,
      size: json['size'] as String,
    );
  }
}

List<Torrent> parseTorrents(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Torrent>((json) => Torrent.fromJson(json)).toList();
}

Future<List<Torrent>> fetchTorrents(String url) async {
  final response = await Client().get(url);

  return compute(parseTorrents, response.body);
}

//url stuff
String getUrl(String searchTerm, {String category = '0'}) {
  searchTerm = searchTerm.replaceAll(RegExp(r' '), '+'); //replace spaces
  return 'https://cors-anywhere.herokuapp.com/https://pirateproxy.ink/api?url=/q.php?q=${searchTerm}&cat=0';
}
