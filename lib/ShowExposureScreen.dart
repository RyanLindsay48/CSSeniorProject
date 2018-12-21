import 'PiExposuresScreen.dart';
import 'Exposure.dart';
import 'Pi.dart';
import 'package:flutter/material.dart';
import 'Picture.dart';

/**
* The ShowExposureScreen Class is used to show the user a list of images from a specific exposure. It also lets the user navigate back
* to the PiExposuresScreen.
*/ 
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
  /**
  * The buildCells method is used to build Containers that contain images from the user's most recent exposure.
  */
  buildCells(int length) {
    List<Container> cells = new List<Container>.generate(length,(int index) {
      return new Container(
        child: new Image.network(pics[index]),
      );
    });
    return cells;
  }
  /**
  * This screen uses a gridView to show each of picture associated to an exposure. It also has a back button that allows the
  * user to navigate back to the PiExposuresScreen.
  */ 
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
                title: new Text(piName +' Exposures'),
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
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 1.3,
                childAspectRatio: 1.60,
                padding: const EdgeInsets.all(10.0),
                crossAxisCount: 2,
                children: buildCells(myPhotos.length),
          ),
        )
      );
  }
}


