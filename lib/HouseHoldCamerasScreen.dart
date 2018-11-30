
import 'dart:async';
import 'dart:convert';

import 'package:actualhousehawk/ExposureList.dart';
import 'package:actualhousehawk/PiExposuresScreen.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'main.dart';
import 'Pi.dart';
import 'package:http/http.dart' as http;
import 'ExposureList.dart';
import 'Exposure.dart';


class HouseHoldCamerasScreen extends StatelessWidget {
  List<Pi> pis = [];




  HouseHoldCamerasScreen(List<Pi> pis){
    this.pis = pis;
  }

  Future<Exposure> fetchExposures(BuildContext context, Pi pi) async {
    print('hello');
    final response = await http.get('http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/pi/exposures?pi_id=' + pi.pi_id.toString());
    print(response.statusCode);
    print('did I get this far');
    //print(response.bodyBytes.toString());
    if (response.statusCode == 200) {
      print(response.body);
      ExposureList expos = new ExposureList.fromJson(json.decode(response.body));
      var size = expos.exposures.length;
      List<Exposure> piExposures = [];
      for(int i = 0; i < size; i++){
        print(expos.exposures[i].toString());
        //adds exposure to list even if it does not contain any photos.
        piExposures.add(expos.exposures[i]);
      }
      print(piExposures.length.toString());
      Navigator.push(context,new MaterialPageRoute(builder: (context) => new PiExposuresScreen(piExposures, pi.location)));
    }
    else {
      print('Cannot recieve photos');

      throw Exception('Failed to load images');
    }
  }

  createButtons(int size, BuildContext context){
    size = pis.length;
    print(size);
    List<RaisedButton> buttons = [];
    for(int i = 0; i < size; i++){
      var piLocation = pis[i].location;
      print(piLocation);
      buttons.add(RaisedButton(child: Text(piLocation),
        onPressed: ()=> fetchExposures(context, pis[i]),
      ));
    }
    return buttons;
  }

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
            body: new Column(
              children: createButtons(pis.length, context)
            )));
  }
}
