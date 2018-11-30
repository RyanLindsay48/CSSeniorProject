import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:actualhousehawk/ExposureList.dart';
import 'package:actualhousehawk/Picture.dart';
import 'package:actualhousehawk/PictureList.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'main.dart';
import 'Pi.dart';
import 'Exposure.dart';
import 'package:http/http.dart' as http;
import 'MostRecentExposureScreen.dart';

class PiExposuresScreen extends StatelessWidget {
  List<Exposure> exposures = [];
  String piName;




  PiExposuresScreen(List<Exposure> exposures, String piName){
    this.exposures = exposures;
    this.piName = piName;
  }


  createButtons(int size, BuildContext context){
    size = exposures.length;
    print(size);
    List<RaisedButton> buttons = [];
    for(int i = 0; i < size; i++){
      var triggerTime = exposures[i].start_time;
      print(triggerTime);
      buttons.add(RaisedButton(child: Text(triggerTime),
        onPressed: ()=> fetchPhotos(context, exposures[i].exposures_id),
      ));
    }
    return buttons;
  }

  Future<File> fetchPhotos(BuildContext context, int exposure_id) async {
    print('hello');
    final response = await http.get('http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/pictures?expo_id=' + exposure_id.toString());
    print(response.statusCode);
    print('did I get this far');
    //print(response.bodyBytes.toString());
    if (response.statusCode == 200) {
      print(response.body);
      PictureList pics = new PictureList.fromJson(json.decode(response.body));
      var size = pics.pictures.length;
      List<Picture> photos = [];
      for(int i = 0; i < size; i++){
        print(pics.pictures[i].filepath);
        List<String> garbage = pics.pictures[i].filepath.split('/');
        print(garbage[6]);
        Picture pic = new Picture();
        pic.expo_id = garbage[4];
        pic.pi_id = garbage[5];
        pic.imageName = garbage[6];
        print(pic.expo_id);
        print(pic.pi_id);
        print(pic.imageName);
        print(pic);
        print(photos);
        photos.add(pic);
      }
      Navigator.push(context,new MaterialPageRoute(builder: (context) => new ShowExposureScreen(photos, exposure_id)));
    }
    else {
      print('Cannot recieve photos');

      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: piName + 'Exposures',
        home: new Scaffold(
            appBar: new AppBar(
                title: new Text(piName +' Camera'),
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
                children: createButtons(exposures.length, context)
            )
        ));
  }
}
