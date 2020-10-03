import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:share/share.dart';
//import 'package:flutter/painting.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Torry/utils/constants.dart' as constants;
import 'dart:js' as js;
import 'dart:html';
import 'package:toast/toast.dart';
import 'package:clippy/browser.dart' as clippy;

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
  return 'https://cors-anywhere.herokuapp.com/https://piratesbay.link/apibay/q.php?q=$searchTerm&cat=$category';
}

String getMagnetLink(String hash, String name) {
  return "magnet:?xt=urn:btih:$hash&amp;dn=${name.replaceAll(r' ', '%20')}&amp;tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.to%3A2920%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&amp;tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.pirateparty.gr%3A6969%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.cyberia.is%3A6969%2Fannounce";
}

void launchMagnetLink(String url) async {
  print(url);
  try {
    await launch(url);
  } catch (e) {
    print(e);
  }
}

Future<bool> canLaunchMagnetLink(String url) async {
  if (await canLaunch(url)) {
    print("can launch");
    return true;
  } else {
    return false;
  }
}

void launchAppLink() async {
  if (await canLaunch(constants.appLink)) {
    await launch(constants.appLink);
  } else {
    throw 'Could not launch appLink';
  }
}

void launchTorryLink() async {
  if (await canLaunch(constants.appLink)) {
    await launch(constants.TorryLink);
  } else {
    throw 'Could not launch appLink';
  }
}

void launchMailUsURI() async {
  String link = constants.mailUs;
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Could not launch appLink';
  }
}

String getDetailsUrl(String id) {
  return 'https://cors-anywhere.herokuapp.com/https://piratesbay.link/apibay/t.php?id=$id';
}

String currentUrl() {
  return js.context['location']['href'];
}

Future<void> share(String url, var context) async {
  if (!kIsWeb) {
    Share.share(url);
  } else {
    copy(url);
    Toast.show("Link copied", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}

void copy(String text) async {
  await clippy.write(text);
}
