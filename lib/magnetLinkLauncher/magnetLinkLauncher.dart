import 'package:flutter/painting.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:torry/utils/constants.dart' as constants;

final String appPackageName = 'com.utorrent.client&hl=en';
final String appLink = 'market://details?id=' + appPackageName;


void launchMagnetLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch magnetLink';
  }
}

Future<bool> canLaunchMagnetLink(String url) async {
  if (await canLaunch(url)){
    return true;
  } else {
    return false;
  }
}

void launchAppLink() async {
  if(await canLaunch(appLink)){
    await launch(appLink);
  }
  else {
    throw 'Could not launch appLink';
  }

}

void launchTorryLink() async{
  if(await canLaunch(appLink)){
    await launch(constants.torryLink);
  }
  else {
    throw 'Could not launch appLink';
  }
}

void launchSaviorLink() async{
  if(await canLaunch(appLink)){
    await launch(constants.saviorLink);
  }
  else {
    throw 'Could not launch appLink';
  }
}

void launchMailUsURI() async{
  String link = constants.mailUs;
  if(await canLaunch(link)){
    await launch(link);
  }
  else {
    throw 'Could not launch appLink';
  }
}