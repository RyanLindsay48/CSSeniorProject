import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'Picture.dart';

class MostRecentExposureScreen extends StatelessWidget {
  List<Picture> photos =[];
  String endpointBegin = 'http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/picture?expo_id=';
  String pi_id = '&pi_id=';//=28
  String imageName = '&image_name=';
  List<NetworkImage> myPhotos =[];

  MostRecentExposureScreen(List<Picture> photos){
    this.photos = photos;
  }

  @override
  Widget build(BuildContext context) {
    for(Picture image in photos){
        String str = endpointBegin + image.getPI() + pi_id + image.getExposure() + imageName + image.getImageName() ;
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
                     )
                 ),
               ),
            )
        )
    );
  }
}


