import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'ShowExposureScreen.dart';

import 'Picture.dart';
import 'PictureList.dart';
import 'package:flutter/material.dart';

import 'Pi.dart';
import 'Exposure.dart';
import 'package:http/http.dart' as http;

import 'HouseHoldCamerasScreen.dart';
import 'TimeStampFormatter.dart';

class PiExposuresScreen extends StatelessWidget {
  List<Exposure> exposures = [];
  String piName;
  List<Pi> pis = [];

  PiExposuresScreen(List<Exposure> exposures, String piName, List<Pi> pis){
    this.exposures = exposures;
    this.piName = piName;
    this.pis = pis;
  }

  createButtons(int size, BuildContext context){
    size = exposures.length;
    print(size);
    List<RaisedButton> buttons = [];
    for(int i = 0; i < size; i++){
      var triggerTime = exposures[i].start_time;
      print(triggerTime);
      String date = triggerTime.substring(0,10);
      String time = triggerTime.substring(11,triggerTime.length);
      buttons.add(RaisedButton(child: Text(TimeStampFormatter.getFormattedDate(date) +
               ' at: ' + TimeStampFormatter.getFormattedTime(time)),
        onPressed: ()=> fetchPhotos(context, exposures[i].exposures_id),
      ));

//      buttons.add(RaisedButton(child: Text(date),
//        onPressed: ()=> fetchPhotos(context, exposures[i].exposures_id),
//      ));
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
        pic.pi_id = garbage[4];
        pic.expo_id = garbage[5];
        pic.imageName = garbage[6];
        print(pic.expo_id);
        print(pic.pi_id);
        print(pic.imageName);
        print(pic);
        print(photos);
        photos.add(pic);
      }
      Navigator.push(context,new MaterialPageRoute(builder: (context) => new ShowExposureScreen(photos,exposures, piName, pis)));
    }
    else {
      print('Cannot recieve photos');

      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
                title: new Text(piName +' Camera'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    tooltip: 'Back to home screen',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HouseHoldCamerasScreen(pis)),
                      );
                    })),
            body:  Padding(
              padding: EdgeInsets.all(10.0),
                child: ListView(
                    children: createButtons(exposures.length,context)
                )
                //createButtons(exposures.length, context)
            )
        ));
  }
}