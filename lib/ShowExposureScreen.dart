import 'PiExposuresScreen.dart';
import 'Exposure.dart';
import 'Pi.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'Picture.dart';

class ShowExposureScreen extends StatelessWidget {
  List<Picture> photos =[];

  String endpointBegin = 'http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/picture?expo_id=';
  String pi_id = '&pi_id=';//=28
  String imageName = '&image_name=';
  List<NetworkImage> myPhotos =[];
  List<Exposure> exposures;
  String piName;
  List<Pi> pis;

  List<String> pics = [];

  ShowExposureScreen(List<Picture> photos,List<Exposure> exposures, String piName, List<Pi> pis){
    this.photos = photos;
    this.exposures = exposures;
    this.piName = piName;
    this.pis = pis;
  }

  buildCells(int length) {
    List<Container> cells = new List<Container>.generate(length,(int index) {
      return new Container(
        child: new Image.network(pics[index]),
      );
    });
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    for(Picture image in photos){
      String str = endpointBegin + image.getExposure() + pi_id + image.getPI() + imageName + image.getImageName();
      myPhotos.add(new NetworkImage(str));
      pics.add(str);
    }
    return new MaterialApp(
        title: 'Image captures screen',
        home: new Scaffold(
            appBar: new AppBar(
                title: new Text(piName +'Exposures from'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    tooltip: 'Back to home screen',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PiExposuresScreen(exposures, piName, pis)),
                      );
            })),
            body:  GridView.count(
                      crossAxisSpacing: 5.0,
                      padding: const EdgeInsets.all(5.0),
                      crossAxisCount: 2,
                      children: buildCells(myPhotos.length),
            ),
        )
      );
  }
}


