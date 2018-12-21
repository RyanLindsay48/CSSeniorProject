
/**
* The Exposure class is used to decode a json file that we request from the server.
* Once the file is decoded we extract the end_time, exposures_id, pi_id, start_time and user_id from the file
*/
class Exposure {
  final String end_time;
  final int exposures_id;
  final int pi_id;
  final String start_time;
  final int user_id;

  Exposure(
      {this.end_time, this.exposures_id, this.pi_id, this.start_time, this.user_id});
  /**
  * The Exposure.fromJson method is used to decode a json file and store the content from that
  * file as an Exposure object.
  */
  factory Exposure.fromJson(Map<String, dynamic> json) {
    return Exposure(
        end_time: json['end_time'],
        exposures_id: json['exposures_id'],
        pi_id: json['pi_id'],
        start_time: json['start_time'],
        user_id: json['user_id']
    );
  }
}
