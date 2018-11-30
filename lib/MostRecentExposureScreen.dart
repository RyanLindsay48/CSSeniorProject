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
import 'Picture.dart';

class ShowExposureScreen extends StatelessWidget {
  //List<String> photos = [];
  List<Picture> photos =[];
  int exposure_id;

  //String testEndpointBeginning = 'http://52.91.107.223:5000/exposure/picture?image_name=';
  //String testEndpointEnd = '&pi_id=2&expo_id=28';
  //http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/picture?pi_id=2&expo_id=28&image_name=image-162614.jpg
  String endpointBegin = 'http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/picture?expo_id=';
  //String pi_id = '&pi_id='; //=2
  String pi_id = '&pi_id=';//=28
  String imageName = '&image_name=';


  List<NetworkImage> myPhotos =[];
  //List<Image> myPhotos = [];


  ShowExposureScreen(List<Picture> photos, int exposure_id){
    this.photos = photos;
    this.exposure_id = exposure_id;
  }


  @override
  Widget build(BuildContext context) {

    for(Picture image in photos){
      String str = endpointBegin + image.getPI() + pi_id + image.getExposure() + imageName + image.getImageName() ;
      myPhotos.add(new NetworkImage(str));
    }
//    //fetchPhotos();
//    for(String str in photos){
//      str = testEndpointBeginning + str + testEndpointEnd;
//      myPhotos.add(new NetworkImage(str));
//    }

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
                  )

              ),
            ),
          )
      )
    );
  }
}


