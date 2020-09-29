import 'package:flutter/material.dart';
import 'package:torry/magnetLinkLauncher/magnetLinkLauncher.dart';
import 'package:torry/dialogBox/dialogBox.dart';
import 'package:torry/constants/constants.dart' as constants;

class addLink extends StatefulWidget {
  @override
  _addLinkState createState() => _addLinkState();
}

class _addLinkState extends State<addLink> {
  final _magnetLinkController = TextEditingController();


  void wraped_downloadMagnetLink(String s) {
    downloadMagnetLink();
  }

  void downloadMagnetLink() async {
    if (await canLaunchMagnetLink(_magnetLinkController.text)) {
      launchMagnetLink(_magnetLinkController.text);
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
    // TODO: implement dispose
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
                onSubmitted: wraped_downloadMagnetLink,
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
            child: Text("Magnet links start with \"magnet:?\"", style: TextStyle(fontSize: 20, color: Colors.blueGrey),),
          )
        ]
        ));
  }
}
