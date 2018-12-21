import 'Exposure.dart';
/**
* The ExposureList Class is used to decode a json file that contains a list of Exposures.
* This class is used when we are trying to get all of the exposures associated to a one of the users
* cameras. 
*/
class ExposureList {
  final List<Exposure> exposures;

  ExposureList(
      {this.exposures});
  /**
  * The ExposureList.fromJson method is used to decode a json file. The json file contains a list of Exposures
  * The method takes each Exposure in the json file makes converts it into a Exposure Object and then it returns 
  * The entire list of Exposure Objects.
  */
  factory ExposureList.fromJson(List<dynamic> parsedJson) {
    List<Exposure> exposures = new List<Exposure>();
    exposures = parsedJson.map((i)=>Exposure.fromJson(i)).toList();
    return new ExposureList(
        exposures: exposures,
    );
  }
}
