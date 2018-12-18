import 'dart:async';
import 'dart:convert';
import 'PiExposuresScreen.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'Pi.dart';
import 'package:http/http.dart' as http;
import 'ExposureList.dart';
import 'Exposure.dart';
import 'AddCamera.dart';


class HouseHoldCamerasScreen extends StatelessWidget {
  List<Pi> pis = [];

  HouseHoldCamerasScreen(List<Pi> pis){
    this.pis = pis;
  }

  Future<Exposure> fetchExposures(BuildContext context, Pi pi) async {

    final response = await http.get('http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/pi/exposures?pi_id=' + pi.pi_id.toString());
    if (response.statusCode == 200) {
      print(response.body);
      ExposureList expos = new ExposureList.fromJson(json.decode(response.body));
      var size = expos.exposures.length;
      List<Exposure> piExposures = [];
      for(int i = 0; i < size; i++){
        piExposures.add(expos.exposures[i]);
      }
      Navigator.push(context,new MaterialPageRoute(builder: (context) => new PiExposuresScreen(piExposures, pi.location, pis)));
    }
    else {
      print('Cannot recieve photos');
      throw Exception('Failed to load images');
    }
  }

  createButtons(int size, BuildContext context){
    size = pis.length;
    List<RaisedButton> buttons = [];
    for(int i = 0; i < size; i++){
      var piLocation = pis[i].location;
      buttons.add(RaisedButton(child: Text(piLocation),
        onPressed: ()=> fetchExposures(context, pis[i]),
      ));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
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
                    }),
                actions: <Widget> [
                  IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: ()
                    {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddCamera(pis)));
                    })
                    ]),
                    body: Padding(
                       padding: EdgeInsets.all(10.0),
                          child: ListView(
                            children: createButtons(pis.length,context)
                          )
        )));
  }
}