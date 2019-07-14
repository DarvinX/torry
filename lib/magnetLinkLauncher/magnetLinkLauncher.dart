import 'package:url_launcher/url_launcher.dart';

final String appPackageName = 'com.bittorrent.client&hl=en';
final String appLink = 'market://details?id=' + appPackageName;

void launchMagnetLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    if(await canLaunch(appLink)){
      await launch(appLink);
    }
    else {
      throw 'Could not launch $url';
    }
  }
}

Future<bool> canLaunchMagnetLink(String url) async {
  if (await canLaunch(url)){
    return true;
  } else {
    return false;
  }
}