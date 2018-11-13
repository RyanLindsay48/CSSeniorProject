import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'main.dart';

class HouseHoldCamerasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Household Cameras',
        home: new Scaffold(
            appBar: new AppBar(
                title: new Text('House Hold Cameras'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    tooltip: 'Back to home screen',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    })),
            body: new Container(
              child: new ListView(children: <Widget>[
                new Text("Your cameras will appear here")
              ]),
            )));
  }
}
