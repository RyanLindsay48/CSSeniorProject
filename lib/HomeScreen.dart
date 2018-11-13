import 'package:flutter/material.dart';
import 'AccountInfoScreen.dart';
import 'HouseHoldCamerasScreen.dart';
import 'MostRecentExposureScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Home Screen',
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Welcome to House Hawk'),
          ),
          body: new Container(
              child: new ListView(
            children: <Widget>[
              new Center(),
              //Page navigation does not currently work
              RaisedButton(
                child: Text('Most recent Exposures'),
                onPressed: () {
                  Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => MostRecentExposureScreen()),
                  );
                },
              ),

              RaisedButton(
                child: Text('Cameras'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HouseHoldCamerasScreen()),
                  );
                },
              ),

              RaisedButton(
                  child: new Text('View My Account Info'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountInfoScreen()),
                    );
                  }),
            ],
          ))),
    );
  }
}
