import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class MostRecentExposureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Most Recent Exposure Screen Screen',
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Most Recent Exposure'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                tooltip: 'Back to home screen',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              )
            ),
            body: new Container(
              child: new ListView(children: <Widget>[
                new Text("You most recent exposure pictures will appear here")
              ]),
            )));
  }
}
