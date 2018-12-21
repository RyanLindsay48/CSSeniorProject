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

/**
* The HouseHoldCamerasScreen Class is used to show all of the cameras associated to a user.
* Shown on this screen are buttons for each of the user's cameras, a back button that navigates back to the HomeScreen and a 
* AddCamera Button that allows a user to add a camera to their account.
*/
class HouseHoldCamerasScreen extends StatelessWidget {
  List<Pi> pis = [];

  HouseHoldCamerasScreen(List<Pi> pis){
    this.pis = pis;
  }
  
  /*
  * The fetchExposures method is used to get all of the exposures associated to a specific camera.
  * It requests a json file of all of the exposures and decodes it into a list of Exposures. The user will then
  * be redirected to the PiExposuresScreen where it will pass over the list of Exposures, the pi's location and the list of Pis too.
  */
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
  /**
  * The layout for this screen is a listView of buttons. Each of the users cameras are displayed as a button.
  * When the user clicks on one of those cameras they will be redirected to the PisExposuresScreen where they will see
  * All the exposures associated with that camera. It also contains a back button and a add camera button on the app bar.
  * The back button redirects the user back to the HomeScreen and the add camera button redirects the user to the AddCamera Screen
  */
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
