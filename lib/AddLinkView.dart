import 'package:flutter/material.dart';
//import 'package:Torry/magnetLinkLauncher/magnetLinkLauncher.dart';
import 'package:Torry/dialogBox/dialogBox.dart';
//import 'package:Torry/utils/constants.dart' as constants;
import 'utils/utils.dart' as utils;

class AddLink extends StatefulWidget {
  @override
  _AddLinkState createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  final _magnetLinkController = TextEditingController();

  void wrapedDownloadMagnetLink(String s) {
    downloadMagnetLink();
  }

  void downloadMagnetLink() async {
    if (await utils.canLaunchMagnetLink(_magnetLinkController.text)) {
      utils.launchMagnetLink(_magnetLinkController.text);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
              title: 'Can\'t find any downloader',
              description:
                  "You need a downoader in order to download things from torrent.",
              buttonText: "later"));
    }
  }

  @override
  void initState() {
    super.initState();
    print('initiated bookmark view');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              new Expanded(
                  child: TextField(
                maxLines: null,
                controller: _magnetLinkController,
                onChanged: null,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    hintText: 'Magnet Link'),
                onSubmitted: wrapedDownloadMagnetLink,
              )),
              IconButton(
                  icon: Icon(Icons.file_download),
                  color: Colors.blue,
                  iconSize: 30,
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  onPressed: downloadMagnetLink),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Magnet links start with \"magnet:?\"",
              style: TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
          )
        ]));
  }
}
