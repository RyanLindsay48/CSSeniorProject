class Exposure {
  final String end_time;
  final int exposures_id;
  final int pi_id;
  final String start_time;
  final int user_id;

  Exposure(
      {this.end_time, this.exposures_id, this.pi_id, this.start_time, this.user_id});

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