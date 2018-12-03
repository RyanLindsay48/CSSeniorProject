import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AddCamera extends StatelessWidget {
  String piSerialNumber;
  String location;
  @override
  // ignore: unused_element
  Widget build(BuildContext context) {
    return new MaterialApp(
      //title: 'Login page',
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                'Add Camera',
              ),
            ),
            body: new Container(
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
                    RaisedButton(child: Text('Create Account'),
                      onPressed: () => postData(context),
                    ),
                  ],
                )
            )
        )
    );
  }

  postData(BuildContext context) async {
    final response = await http.put(
        'http://52.91.107.223:5000/pi?user_id=42&location=' + location + '&serial_number=' + piSerialNumber);
    print(response.statusCode);

  }
}