class HouseHold {
  final int household_id;
  final String street_address;
  final String apartment_num;
  final String state;
  final String city;
  final String zip_code;

  /**
  * The HouseHold Class is to store the user's house information as a HouseHold Object where it will then be used to set the global variables.
  */
  HouseHold(
      {this.household_id, this.street_address, this.apartment_num,this.state, this.city,this.zip_code});
  /**
  * The HouseHold.fromJson method is used to decode a json file and store the contents of that json file as a HouseHold Object.
  */
  factory HouseHold.fromJson(Map<String, dynamic> json) {
    return HouseHold(
        apartment_num: json['apartment_num'],
        city: json['city'],
        household_id: json['household_id'],
        state: json['state'],
        street_address: json['street_address'],
        zip_code: json['zip_code']
    );
  }
}
