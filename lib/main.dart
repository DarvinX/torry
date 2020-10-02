import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Torry/HomePage.dart';
import 'package:Torry/utils/constants.dart' as constants;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void main() => runApp(TorryMain());

class TorryMain extends StatelessWidget {
  //Parent Widget
  @override
  Widget build(BuildContext context) {
    constants.launchId = js.context['location']['href'].split('/').last;
    print("from main" + constants.launchId);
    return Container(
      child: HomePage(),
    );
  }
}
