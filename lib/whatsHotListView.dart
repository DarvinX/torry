import 'package:flutter/material.dart';
import 'package:torry/utils/constants.dart' as constants;
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'dart:async';
import 'package:torry/magnetLinkLauncher/magnetLinkLauncher.dart';

class whatsHotListView extends StatefulWidget {
  @override
  _whatsHotListViewState createState() => _whatsHotListViewState();
}

class _whatsHotListViewState extends State<whatsHotListView> {
  List<String> _categories = constants.categories;
  Map<String, String> _categoryMap = constants.categoryMap;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _categories.length,
      padding: EdgeInsets.all(5),
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ExpandableListView(
              title: _categories[index],
            )
          ], //
        );
      },
    ));
  }
}

class ExpandableListView extends StatefulWidget {
  final String title;

  const ExpandableListView({Key key, this.title}) : super(key: key);

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView>
    with AutomaticKeepAliveClientMixin<ExpandableListView> {
  bool isPerformingRequest = false;
  bool expandFlag = false;
  List<String> loadedFiles = [];
  List<String> bookmarkedFiles = [];
  List<String> _categories = constants.categories;
  Map<String, String> _categoryMap = constants.categoryMap;
  List<Map<String, dynamic>> _primaryLinkMap = [];
  List<String> _url = constants.url;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('initiated');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //print('disposed');
  }


  Future<String> getMagnetLink(dom.Element link, int index) async {
    //extract the magnet link
    var client = Client();
    Response res = await client.get(_url[index] + link.attributes['href']);
    var document = parse(res.body);
    var magnetLink =
        document.querySelector('div.download > a').attributes['href'];
    //print(magnetLink);
    return (magnetLink);
  }

  Future _getList(String mapKey) async {
    isPerformingRequest = true;

    //create a map of file name and magnet link
    String searchTerm = _categoryMap[mapKey];
    Response response;
    int index = 0;
    setState(() {});
    var client = Client();
    int i = 0;

    do {
      String url = _url.elementAt(index);
      //print(url + searchTerm);

      response = await client.get(url + searchTerm);

      index++;
    } while (response.statusCode != 200);

    index = index - 1;

    var document = parse(response.body);
    List<dom.Element> searchResults = document.querySelectorAll('tbody > tr');

    for (var searchResult in searchResults) {
      if (!expandFlag) {
        return 0;
      }
      if (i <= 30) {
        i++;
      } else {
        return 0;
      }
      //print('loop starting');
      dom.Element link = searchResult.querySelector('a.detLink');
      if (loadedFiles.contains(link.text)) {
        continue;
      }
      List<String> details =
          searchResult.querySelector('font').text.split(', ');
      List<dom.Element> seedLeech = searchResult.querySelectorAll('td');
      String seeds = seedLeech[2].text;
      String leechs = seedLeech[3].text;
      //print(seeds);
      try {
        String magnetLink = await getMagnetLink(link, index);
        _primaryLinkMap.add({
          'title': link.text,
          'magnetLink': magnetLink,
          'date': details[0],
          'size': details[1],
          'seeds': seeds,
          'leechs': leechs,
        });
        loadedFiles.add(link.text);
        setState(() {});
      } catch (e) {}
    }
    //print(primaryLinkMap.length);
    isPerformingRequest = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(3, 10, 15, 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 20),
              ),
              padding: EdgeInsets.all(10),
            )),
            IconButton(
                icon: Icon(
                  expandFlag
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    if(!expandFlag){
                    _getList(widget.title);
                    }
                    expandFlag = !expandFlag;

                  });
                }),
          ],
        ),
      ),
      ExpandableContainer(
          expanded: expandFlag,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index == _primaryLinkMap.length) {
                return _buildProgressIndicator();
              } else {
                return Container(
                  child: Card(
                      child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 0, 7),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    _primaryLinkMap[index]['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(bottom: 5),
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          _primaryLinkMap[index]['date'],
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          _primaryLinkMap[index]['size'],
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                    Expanded(
                                        child: Column(
                                      children: <Widget>[
                                        Text(
                                          'seeders ' +
                                              _primaryLinkMap[index]['seeds'],
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          'leechers ' +
                                              _primaryLinkMap[index]['leechs'],
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    ))
                                  ],
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            )),
                            IconButton(
                                icon: Icon(Icons.file_download),
                                onPressed: () async {
                                  String magLink = _primaryLinkMap[index]['magnetLink'];
                                  if(await canLaunchMagnetLink(constants.dummyMagLink)){
                                    //print('interstitial add');
                                  }

                                  launchMagnetLink(magLink);
                                }),
                            IconButton(
                                icon: Icon(bookmarkedFiles.contains(
                                        _primaryLinkMap[index]['title'])
                                    ? Icons.bookmark
                                    : Icons.bookmark_border),
                                onPressed: () async {
                                  String title =
                                      _primaryLinkMap[index]['title'];
                                  setState(() {});
                                })
                          ],
                        ),
                      )
                    ],
                  )),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black12,
                    ),
                  ),
                );
              }
            },
            itemCount: _primaryLinkMap.length + 1,
          ))
    ]));
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.redAccent,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
        duration: new Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: screenWidth,
        height: expanded ? expandedHeight : collapsedHeight,
        child: new Container(
          child: child,
        ));
  }
}
