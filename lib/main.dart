import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:torry/constants/constants.dart' as constants;
import 'whatsHotListView.dart';
import 'searchView.dart';
import 'bookmarkListView.dart';

void main() => runApp(TorryMain());

class TorryMain extends StatelessWidget {
  //Parent Widget
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  //Child Dynamic Widget
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage>
    with SingleTickerProviderStateMixin {
  // constants
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // theme
          brightness: Brightness.light,
          primaryColor: Colors.redAccent,
          accentColorBrightness: Brightness.dark),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Torry',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            // Create Tabs
            bottom: TabBar(
                labelStyle: TextStyle(fontSize: 15),
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: Icon(Icons.search,),
                  ),
                  Tab(
                    icon: Icon(Icons.whatshot),
                  ),
                  Tab(
                    icon: Icon(Icons.bookmark_border),
                  ),
                ]),
          ),
          body: TabBarView(controller: _tabController, children: [
            Container(
                child: searchView()),
            Container(
              child: whatsHotListView(),
            ),
            Container(
              child: bookmarkListView(),
            )
          ]),
        ),
      ),
    );
  }

}
