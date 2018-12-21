import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Globals.dart' as globals;
import 'Pi.dart';
import 'HouseHoldCamerasScreen.dart';

/*
The main functionality of this class is to add a camera associated to the user that is signed in.
Users are prompted to enter in the serial number for the camera and the location of the camera.
We then post the information back onto our server.
 */
class AddCamera extends StatelessWidget {
  static String piSerialNumber;
  static String location;
  List<Pi> pis;

  AddCamera(this.pis);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                'Add Camera',
              ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HouseHoldCamerasScreen(pis)),
                    );
              })
            ),
            body: Padding(
                padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
                    new Center(
                      child: new TextField(
                          decoration: new InputDecoration(
                              labelText: 'Camera Serial Number'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('Cameras Text is:  $text');
                            piSerialNumber = text;
                          }
                      ),
                    ),
                    new TextField(
                        decoration: new InputDecoration(
                            labelText: 'Camera Location'
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (text) {
                          print('Camera Location:  $text');
                          location = text;
                        }
                    ),
                    RaisedButton(child: Text('Add Camera'),
                      onPressed: () => postData(context),
                    ),
                  ],
                )
            )
        )
    );
  }
  /*
  postData method is used to post info about a user's camera back to the server.
   */
  postData(BuildContext context) async {
    print(globals.userID.toString());
    final response = await http.post(
        'http://52.91.107.223:5000/pi?user_id='+ globals.userID.toString() + '&location=' + location + '&serial_number=' + piSerialNumber);
    print(response.statusCode);
    Navigator.push(context,new MaterialPageRoute(builder: (context) => new HouseHoldCamerasScreen(pis)));
  }
}