import 'Exposure.dart';

class ExposureList {
  final List<Exposure> exposures;

  ExposureList(
      {this.exposures});

  factory ExposureList.fromJson(List<dynamic> parsedJson) {
    List<Exposure> exposures = new List<Exposure>();
    exposures = parsedJson.map((i)=>Exposure.fromJson(i)).toList();
    return new ExposureList(
        exposures: exposures,
    );
  }
}