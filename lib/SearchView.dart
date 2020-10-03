import 'dart:convert';
//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'dart:async';
import 'package:Torry/utils/constants.dart' as constants;
//import 'package:Torry/torrDatabase/torrDatabase.dart';
import 'package:Torry/urlMods/urlMods.dart';
import 'package:Torry/dialogBox/dialogBox.dart';
import 'package:share/share.dart';
import 'package:Torry/utils/utils.dart' as utils;
import 'package:filesize/filesize.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String sortBy;
  String searchType;
  String category = '0';
  final _movieSearchController = TextEditingController();
  //final List<String> _url = constants.url;
  List<String> loadedFiles = [];
  List<String> bookmarkedFiles = [];
  List<Map<String, dynamic>> _primaryLinkMap = [];
  List<String> suggestions = ['tamal', 'hansda'];
  bool isPerformingRequest;
  bool needSuggestions = true;
  bool _noResult = false;

  Future _getList({String initId = "", bool fromInit = false}) async {
    if (initId == "" && fromInit) {
      return 0;
    }
    suggestions = [];
    needSuggestions = false;
    isPerformingRequest = true;
    _noResult = false;
    //create a map of file name and magnet link
    String searchTerm = _movieSearchController.text;
    Response response;

    _primaryLinkMap.clear();
    setState(() {});
    var client = Client();

    String codedUrl = getDecodedUrl(sortBy, searchType, searchTerm);
    for (var i = 0; i < constants.nRetry; i++) {
      String url = initId == ""
          ? utils.getUrl(searchTerm, category: category)
          : utils.getDetailsUrl(initId);
      print(url);
      try {
        response = await client.get(url).then((value) {
          print(value.request);
          return value;
        });
        break;
      } catch (err) {
        print(err);
      }
    }
    print("site is working");

    var searchResults = initId == ""
        ? json.decode(response.body)
        : [json.decode(response.body)];

    //print(searchResults);

    print("collected search results " + searchResults.length.toString());
    if (searchResults.length == 0) {
      print("no result found");
      isPerformingRequest = false;
      _noResult = true;
      setState(() {});
      return 0;
    }
    for (var searchResult in searchResults) {
      //print('itering');
      try {
        String tempCodedUrl =
            getDecodedUrl(sortBy, searchType, _movieSearchController.text);
        //print('searching for $codedUrl and $tempCodedUrl');
        if (codedUrl != tempCodedUrl) {
          print('stopping');
          isPerformingRequest = false;
          _noResult = true;
          return 0;
        }

        //collect data from json
        String id = searchResult['id'];
        String name = searchResult['name'];
        String seeds = searchResult['seeders'];
        String leechs = searchResult['seeders'];
        String dateMillis = searchResult['added'];
        String sizeBytes = searchResult['size'];
        String hash = searchResult['info_hash'];

        //format the dates
        var now = new DateTime.fromMillisecondsSinceEpoch(
            int.parse(dateMillis) * 1000);
        String date =
            "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

        //format filesize
        String size = filesize(sizeBytes);

        //generate magnet link
        String magnetLink = utils.getMagnetLink(hash, name);

        //skip the result if it has no seeder
        if (int.parse(seeds) == 0) {
          print("skipped a result");
          continue;
        }

        try {
          _primaryLinkMap.add({
            'id': id,
            'title': name,
            'magnetLink': magnetLink,
            'date': date,
            'size': size,
            'seeds': seeds,
            'leechs': leechs,
          });
          //print('New result added');
          //setState(() {});
        } catch (e) {
          print(e);
          continue;
        }
      } catch (e) {
        print(e);
        continue;
      }
    }
    //print(primaryLinkMap.length);
    isPerformingRequest = false;
    if (_primaryLinkMap.length == 0) {
      _noResult = true;
    } else {}
    print("end of _getList");
    print(_primaryLinkMap.length);
    setState(() {});
    return 0;
  }

  Future _getSuggestions() async {
    needSuggestions = true;
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
    }
    setState(() {});
  }

  void wrapedGetList(String s) {
    _getList();
  }

  @override
  void dispose() {
    _movieSearchController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    isPerformingRequest = false;
    needSuggestions = false;
    print('initstate');
    print(constants.launchId);
    _getList(initId: constants.launchId, fromInit: true);
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
                        onSubmitted: wrapedGetList,
                      )),
                      IconButton(
                        icon: Icon(Icons.search),
                        iconSize: 30,
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
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
                    /*Container(
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
                    ),*/
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
                            category = constants.categoryMap[text];
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
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                            'seeders: ' +
                                                _primaryLinkMap[index]['seeds'],
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          Text(
                                            'leechers: ' +
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
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: const EdgeInsets.all(0.0),
                                      //height: 30.0,
                                      width: 30.0,
                                      child: IconButton(
                                          color: Colors.blue,
                                          iconSize: 30,
                                          padding: EdgeInsets.all(0.0),
                                          icon: Icon(Icons.file_download),
                                          onPressed: () async {
                                            try {
                                              utils.launchMagnetLink(
                                                  _primaryLinkMap[index]
                                                      ['magnetLink']);
                                            } catch (e) {
                                              print(e);
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      CustomDialog(
                                                          title:
                                                              'Can\'t find any downloader',
                                                          description:
                                                              "You need a downoader in order to download things from torrent.",
                                                          buttonText: "later"));
                                            }

                                            //
                                            //    _primaryLinkMap[index]
                                            //        ['magnetLink']);
                                          })),
                                  Column(
                                    children: <Widget>[
                                      /*Container(
                                          padding: const EdgeInsets.all(0.0),
                                          height: 40.0,
                                          width: 30.0,
                                          child: IconButton(
                                              iconSize: 25,
                                              color: Colors.blueGrey,
                                              icon: Icon(
                                                  bookmarkedFiles.contains(
                                                          _primaryLinkMap[index]
                                                              ['title'])
                                                      ? Icons.bookmark
                                                      : Icons.bookmark_border),
                                              onPressed: () async {
                                                String title =
                                                    _primaryLinkMap[index]
                                                        ['title'];
                                                setState(() {});
                                              })),*/
                                      /*Container(
                                          padding: const EdgeInsets.all(0.0),
                                          //height: 40.0,
                                          width: 40.0,
                                          child: IconButton(
                                            color: Colors.blueGrey,
                                            iconSize: 25,
                                            icon: Icon(Icons.share),
                                            onPressed: () {
                                              var content =
                                                  _primaryLinkMap[index];
                                              utils.share(
                                                  utils.currentUrl() +
                                                      _primaryLinkMap[index]
                                                          ['id'],
                                                  context);
                                            },
                                          )),*/
                                    ],
                                  )
                                ],
                              )
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
    return _noResult
        ? Container(
            child: Column(
            children: <Widget>[
              Icon(
                Icons.sentiment_dissatisfied,
                size: 50,
                color: Colors.blueGrey,
              ),
              Text(
                "No results found...",
                style: TextStyle(fontSize: 30, color: Colors.grey),
              ),
            ],
          ))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Opacity(
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
