class HouseHold {
  final int household_id;
  final String street_address;
  final String apartment_num;
  final String state;
  final String city;
  final String zip_code;


  HouseHold(
      {this.household_id, this.street_address, this.apartment_num,this.state, this.city,this.zip_code});

  //factory User.fromJson(Map<String, String> json) => _$UserFromJson(json);
  //Map<String, String> toJson() => _$UserToJson(this);

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