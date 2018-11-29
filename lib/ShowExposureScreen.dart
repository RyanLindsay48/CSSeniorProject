import 'dart:async';
import 'dart:io';
import 'package:actualhousehawk/User.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

class ShowExposureScreen extends StatelessWidget {
  List<String> photos = [];
  List<ArchiveFile> images = [];
  List<File> files = [];
  String testEndpointBeginning = 'http://52.91.107.223:5000/exposure/picture?image_name=';
  String testEndpointEnd = '&pi_id=2&expo_id=28';
  List<NetworkImage> myPhotos = [];
  //List<Image> myPhotos = [];


  ShowExposureScreen(List<String> photos){
    this.photos = photos;
  }


  @override
  Widget build(BuildContext context) {
    //fetchPhotos();
    for(String str in photos){
      str = testEndpointBeginning + str + testEndpointEnd;
      myPhotos.add(new NetworkImage(str));
    }

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
                  })),
          body: Center(
            child: new Container(
              child: new SizedBox(
                  height: 300.0,
                  width: 300.0,
                  child: new Carousel(
                      images: myPhotos
//                      [
//                      new NetworkImage(photos[0]),
//                      new NetworkImage(photos[1]),
//                      new NetworkImage(photos[2]),
//                      new NetworkImage(photos[3]),
//                      new NetworkImage(photos[4])
//                      ],
                  )

              ),
            ),
          )
      )
    );
  }
}


