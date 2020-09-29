import 'package:flutter/material.dart';
import 'package:torry/magnetLinkLauncher/magnetLinkLauncher.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 60.0;
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.buttonText,
      this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text('Later', style: TextStyle(fontSize: 20),),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          launchAppLink();},
                        child: Text(
                          'Install Now',
                          style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            child: Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.blueAccent,
              size: 100.0,
            ),
            backgroundColor: Colors.white,
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }
}
