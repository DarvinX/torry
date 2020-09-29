import 'package:flutter/material.dart';
import 'package:torry/HomePage.dart';

void main() => runApp(TorryMain());

class TorryMain extends StatelessWidget {
  //Parent Widget
  @override
  Widget build(BuildContext context) {
    return Container(
      child: HomePage(),
    );
  }
}