import 'package:flutter/material.dart';
import 'whatsHotListView.dart';
import 'searchView.dart';
import 'bookmarkListView.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:torry/constants/constants.dart' as constants;
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

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: constants.keyWords,
    childDirected: false,
    testDevices: constants.testDeviceId, // Android emulators are considered test devices
  );

  BannerAd myBanner = BannerAd(
    adUnitId: constants.mainBannerAdId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      //print("BannerAd event is $event");
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    FirebaseAdMob.instance.initialize(appId: constants.appId);
    myBanner
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    myBanner?.dispose();

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
                  /*Tab(
                    icon: Icon(Icons.whatshot),
                  ), */
                  Tab(
                    icon: Icon(Icons.bookmark_border),
                  ),
                ]),
          ),
          body: TabBarView(controller: _tabController, children: [
            Container(
                child: searchView()),
            /*
            Container(
              child: whatsHotListView(),
            ), */
            Container(
              child: bookmarkListView(),
            )
          ]),
        ),
      ),
    );
  }

}
