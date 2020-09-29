import 'package:flutter/material.dart';
import 'package:torry/magnetLinkLauncher/magnetLinkLauncher.dart';
import 'package:torry/torrDatabase/torrDatabase.dart';
import 'package:torry/constants/constants.dart' as constants;

class bookmarkListView extends StatefulWidget {
  @override
  _bookmarkListViewState createState() => _bookmarkListViewState();
}

class _bookmarkListViewState extends State<bookmarkListView> {

  List<Map<String, dynamic>> _bookmarkMap = [];
  List<String> bookmarkedFiles = [];

  bookmarkMap() async {
    return await TorrentDatabase.instance.torrents();
  }

  _updateBookmarks() async {
    _bookmarkMap = await TorrentDatabase.instance.torrents();
    int len = _bookmarkMap.length;
    for (var i = 0; i < len; i++) {
      bookmarkedFiles.add(_bookmarkMap[i]['title']);
    }
    print('names');
    print(_bookmarkMap);
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateBookmarks();
    print('initiated bookmark view');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_bookmarkMap.length == 0){
      return Center(
        child: Text('No Bookmarks', style: TextStyle(fontSize: 50, color: Colors.grey),),
      );
    } else {
      return Container(
        child: ListView.builder(
            itemCount: _bookmarkMap.length,
            padding: const EdgeInsets.all(10.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
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
                                        _bookmarkMap[index]['title'],
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
                                              _bookmarkMap[index]['date'],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            Text(
                                              _bookmarkMap[index]['size'],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                        ),
                                        Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'seeders ' +
                                                      _bookmarkMap[index]['seeds'],
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                      fontStyle: FontStyle
                                                          .italic),
                                                ),
                                                Text(
                                                  'leechers ' +
                                                      _bookmarkMap[index]['leechs'],
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                      fontStyle: FontStyle
                                                          .italic),
                                                )
                                              ],
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                            ))
                                      ],
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                )),
                            IconButton(
                                icon: Icon(Icons.file_download),
                                color: Colors.blue,
                                onPressed: () async {
                                  if (await canLaunchMagnetLink(
                                      constants.dummyMagLink)) {
                                  }
                                  launchMagnetLink(
                                      _bookmarkMap[index]['magnetLink']);
                                }),
                            IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.blueGrey,
                                onPressed: () async {
                                  String title = _bookmarkMap[index]['title'];
                                  bool bookmarked =
                                  bookmarkedFiles.contains(title);

                                  if (!bookmarked) {
                                    TorrentDatabase.instance.insert(
                                        Torrent.fromMap(_bookmarkMap[index]));
                                    bookmarkedFiles.add(title);
                                    print('bookmarked');
                                  } else {
                                    TorrentDatabase.instance.deleteTorrent(
                                        title);
                                    bookmarkedFiles.remove(title);
                                    print('bookmark removed');
                                  }
                                  _updateBookmarks();
                                })
                          ],
                        ),
                      )
                    ],
                  ));
            }
        ),
      );
    }
  }
}
