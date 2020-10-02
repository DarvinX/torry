import 'WhatsHotListView.dart';
import 'package:flutter/material.dart';
import 'SearchView.dart';
//import 'bookmarkListView.dart';
import 'package:Torry/utils/constants.dart' as constants;
import 'utils/utils.dart' as utils;
import 'package:share/share.dart';
import 'package:Torry/AddLinkView.dart';

class HomePage extends StatefulWidget {
  //Child Dynamic Widget
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
      title: 'Torry',
      theme: ThemeData(
          // theme
          brightness: Brightness.light,
          primaryColor: Colors.redAccent,
          accentColorBrightness: Brightness.dark),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: Container(
              width: 250,
              child: Drawer(
                child: Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.share, size: 25),
                        title: Text(
                          'Share',
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                        onTap: () {
                          Share.share(constants.shareText);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.rate_review, size: 25),
                        title: Text(
                          'Review',
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                        onTap: () {
                          utils.launchTorryLink();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.mail_outline, size: 25),
                        title: Text(
                          'Contact Us',
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                        onTap: () {
                          utils.launchMailUsURI();
                        },
                      ),
                      /*
                      Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  height: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 5),
                                          child: Text(
                                            'Our Other Apps',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic),
                                          )),
                                      Expanded(
                                          child: Container(
                                        child: ListTile(
                                          leading: Icon(Icons.apps),
                                          title: Text(
                                            'WhatsApp Savior',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          onTap: () => launchSaviorLink(),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  color: Colors.black)),
                                        ),
                                      ))
                                    ],
                                  ))))
                    */
                    ],
                  ),
                ),
              )),
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
                    icon: Icon(Icons.link),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.search,
                    ),
                  ),
                  /*Tab(
                    icon: Icon(Icons.WhatsHot),
                  ), */
                  Tab(
                    icon: Icon(Icons.bookmark_border),
                  ),
                ]),
          ),
          body: TabBarView(controller: _tabController, children: [
            Container(
              child: AddLink(),
            ),
            Container(child: SearchView()),
            Container(
              child: WhatsHotListView(),
            ),
            /*
            Container(
              child: bookmarkListView(),
            )*/
          ]),
        ),
      ),
    );
  }
}
