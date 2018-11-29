class Pi{
  String location;
  int pi_id;
  int reset;
  String serial_number;
  int user_id;

  Pi({this.location, this.pi_id, this.reset, this.serial_number, this.user_id});

  factory Pi.fromJson(Map<String, dynamic> json) {
    return Pi(
        location: json['location'],
        pi_id: json['pi_id'],
        reset: json['reset'],
        serial_number: json['serial_number'],
        user_id: json['user_id']
    );
  }
}
