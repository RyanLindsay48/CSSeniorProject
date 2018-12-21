import 'Pi.dart';

/**
* The PiList class is used to decode a json file and convert that file into a list of Pi Objects
*/
class PiList {
  final List<Pi> pis;

  PiList(
      {this.pis});
  /**
  * The PiList.fromJson method is used to convert a json file and store each Pi from that json file into a PiList object.
  */
  factory PiList.fromJson(List<dynamic> parsedJson) {
    List<Pi> pis = new List<Pi>();
    pis = parsedJson.map((i)=>Pi.fromJson(i)).toList();
    return new PiList(
      pis: pis,
    );
  }
}
