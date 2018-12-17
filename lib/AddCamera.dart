import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'Globals.dart' as globals;
import 'HomeScreen.dart';

class AddCamera extends StatelessWidget {
  static String piSerialNumber;
  static String location;
  @override
  // ignore: unused_element
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                'Add Camera',
              ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
              })
            ),
            body: Padding(
                padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
                    new Center(
                      child: new TextField(
                          decoration: new InputDecoration(
                              labelText: 'Camera Serial Number'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('Cameras Text is:  $text');
                            piSerialNumber = text;
                          }
                      ),
                    ),
                    new TextField(
                        decoration: new InputDecoration(
                            labelText: 'Camera Location'
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (text) {
                          print('Camera Location:  $text');
                          location = text;
                        }
                    ),
                    RaisedButton(child: Text('Add Camera'),
                      onPressed: () => postData(context),
                    ),
                  ],
                )
            )
        )
    );
  }

  postData(BuildContext context) async {
    print(globals.userID.toString());
    final response = await http.post(
        'api'+ globals.userID.toString() + '&location=' + location + '&serial_number=' + piSerialNumber);
    print(response.statusCode);
    Navigator.push(context,new MaterialPageRoute(builder: (context) => new HomeScreen()));


  }
}
