import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:torry/magnetLinkLauncher/magnetLinkLauncher.dart';
import 'dart:async';
import 'package:torry/constants/constants.dart' as constants;
import 'package:torry/torrDatabase/torrDatabase.dart';
import 'package:torry/urlMods/urlMods.dart';
import 'package:firebase_admob/firebase_admob.dart';

class searchView extends StatefulWidget {
  @override
  _searchViewState createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {
  String sortBy;
  String searchType;
  final _movieSearchController = TextEditingController();
  final List<String> _url = constants.url;
  List<String> loadedFiles = [];
  List<String> bookmarkedFiles = [];
  List<Map<String, dynamic>> _primaryLinkMap = [];
  List<String> suggestions = ['tamal', 'hansda'];
  final _searchProtocol = '/s/?q=';
  bool isPerformingRequest;
  bool needSuggestions = true;

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: constants.keyWords,
    childDirected: false,
    testDevices: constants.testDeviceId,
  );
  InterstitialAd _downloadButtonAd = InterstitialAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId: constants.interstitialAdId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      //print("InterstitialAd event is $event");
    },
  );

  InterstitialAd _bookmarkButtonAd = InterstitialAd(
    adUnitId: constants.bookmarkInterstitialAdId,
    targetingInfo:  targetingInfo,
  );


  InterstitialAd _searchButtonAd = InterstitialAd(
    adUnitId: constants.searchButtonAdId,
    targetingInfo:  targetingInfo,
  );

  _updateBookmarks() async {
    bookmarkedFiles = [];
    List marks = await TorrentDatabase.instance.bookmarkedList();
    int len = marks.length;
    for (var i = 0; i < len; i++) {
      bookmarkedFiles.add(marks[i]['title']);
    }
    //print(bookmarkedFiles);
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

  Future _getList() async {
    _searchButtonAd.show();
    suggestions = [];
    needSuggestions = false;
    isPerformingRequest = true;
    _updateBookmarks();
    //create a map of file name and magnet link
    String searchTerm = _movieSearchController.text;
    Response response;
    int index = 0;

    _primaryLinkMap = [];
    setState(() {});
    var client = Client();

    //searchTerm = searchTerm.replaceAll(RegExp(r' '), '+'); //replace spaces
    String codedUrl = getDecodedUrl(sortBy, searchType, searchTerm);

    do {
      String url =
          _url.elementAt(index) + codedUrl;
      print(url);
      response = await client.get(url);

      index++;
    } while (response.statusCode != 200);

    index = index - 1;

    var document = parse(response.body);
    List<dom.Element> searchResults = document.querySelectorAll('tbody > tr');

    for (var searchResult in searchResults) {
      String tempCodedUrl = getDecodedUrl(sortBy, searchType, searchTerm);
      print('searching for $codedUrl and $tempCodedUrl');
      if (codedUrl != tempCodedUrl) {
        isPerformingRequest = false;
        return 0;
      }
      dom.Element link = searchResult.querySelector('a.detLink');
      List<String> details =
          searchResult.querySelector('font').text.split(', ');
      List<dom.Element> seedLeech = searchResult.querySelectorAll('td');
      String seeds = seedLeech[2].text;
      if (int.parse(seeds) == 0) {
        continue;
      }
      String leechs = seedLeech[3].text;
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
        //print('New result added');
        setState(() {});
      } catch (e) {}
    }
    //print(primaryLinkMap.length);
    isPerformingRequest = false;
  }

  Future _getSuggestions() async {
    needSuggestions = true;
    //create a map of file name and magnet link
    String searchTerm = _movieSearchController.text;
    Response response;
    suggestions = [];
    setState(() {});
    var client = Client();

    searchTerm = searchTerm.replaceAll(RegExp(r' '), '+'); //replace spaces
    response = await client.get(constants.getAPIUrl(searchTerm));

    var document = parse(response.body);
    List<dom.Element> searchResults = document.querySelectorAll('suggestion');

    for (var searchResult in searchResults) {
      String tempTerm =
          _movieSearchController.text.replaceAll(RegExp(r' '), '+');
      //print('searching for $searchTerm and $tempTerm');
      if (tempTerm != searchTerm) {
        return 0;
      }
      String sug = searchResult.attributes['data'];
      suggestions.add(sug);
      //print('get suggestions');
      //print(suggestions);
      //print(primaryLinkMap.length);
    }
    setState(() {});

  }

  void wraped_getList(String s) {
    _getList();
   }

  @override
  void dispose() {
    _movieSearchController.dispose();
    super.dispose();
    _downloadButtonAd?.dispose();
    _bookmarkButtonAd?.dispose();
    _searchButtonAd?.dispose();
  }

  @override
  initState() {
    super.initState();
    _searchButtonAd.load();
    _bookmarkButtonAd.load();
    _downloadButtonAd.load();
    // Add listeners to this class
    isPerformingRequest = false;
    needSuggestions = false;
    print('initstate');
    _getSuggestions();
    _updateBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    //print('searchbar');
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                          child: TextField(
                        controller: _movieSearchController,
                        onChanged: (text) async {
                          _getSuggestions();
                        },
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            hintText: 'Search Torrent'),
                        onSubmitted: wraped_getList,
                      )),
                      IconButton(
                        icon: Icon(Icons.search),
                        iconSize: 30,
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                        focusColor: Colors.blue,
                        onPressed: () async {
                          _getList();
                        },
                      ),
                    ],
                  )),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton(
                        hint: Text('Sort by'),
                        value: sortBy,
                        items: constants.sortByList.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                        onChanged: (text) {
                          setState(() {
                            sortBy = text;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: DropdownButton(
                        hint: Text('Type'),
                        value: searchType,
                        items: constants.searchTypeList.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (text) {
                          setState(() {
                            searchType = text;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: RaisedButton(
                          elevation: 3,
                          textColor: Colors.grey,
                          color: Colors.white,
                          child: Text(
                            "Apply",
                            style: TextStyle(fontSize: 17),
                          ),
                          onPressed: () {
                            _getList();
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0))),
                    )
                  ],
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount:
              needSuggestions ? suggestions.length : _primaryLinkMap.length + 1,
          padding: const EdgeInsets.all(10.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (needSuggestions) {
              //print('suggestions');
              //print(suggestions);
              return GestureDetector(
                  onTap: () {
                    _movieSearchController.text = suggestions[index];
                    _movieSearchController.selection = TextSelection.collapsed(
                        offset: _movieSearchController.text.length);
                    _getList();
                  },
                  child: Card(
                      elevation: 3,
                      margin: EdgeInsets.all(3),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Text(
                          suggestions[index],
                          style: TextStyle(fontSize: 20),
                        ),
                      )));
            } else {
              if (index == _primaryLinkMap.length) {
                return _buildProgressIndicator();
              } else {
                return Card(
                    elevation: 5,
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
                                                _primaryLinkMap[index]
                                                    ['leechs'],
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
                                    if(await canLaunchMagnetLink(constants.dummyMagLink)){
                                      _downloadButtonAd.show();
                                    }
                                    launchMagnetLink(
                                      _primaryLinkMap[index]['magnetLink']);}),
                              IconButton(
                                  icon: Icon(bookmarkedFiles.contains(
                                          _primaryLinkMap[index]['title'])
                                      ? Icons.bookmark
                                      : Icons.bookmark_border),
                                  onPressed: () async {
                                    String title =
                                        _primaryLinkMap[index]['title'];
                                    bool bookmarked =
                                        bookmarkedFiles.contains(title);

                                    if (!bookmarked) {
                                      TorrentDatabase.instance.insert(
                                          Torrent.fromMap(
                                              _primaryLinkMap[index]));
                                      bookmarkedFiles.add(title);
                                      //print('bookmarked');
                                    } else {
                                      TorrentDatabase.instance
                                          .deleteTorrent(title);
                                      bookmarkedFiles.remove(title);
                                      //print('bookmark removed');
                                    }
                                    _bookmarkButtonAd.show();
                                    //_updateBookmarks();
                                    setState(() {});
                                  })
                            ],
                          ),
                        )
                      ],
                    ));
              }
            }
          },
        ))
      ],
    );
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