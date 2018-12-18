class User {
  final String email_address;
  final String fname;
  final String lname;
  final String password;
  final int updated;
  final int user_id;

  User(
      {this.email_address, this.fname, this.lname, this.password,this.updated, this.user_id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email_address: json['email_address'],
      fname: json['fname'],
      lname: json['lname'],
      password: json['password'],
      updated: json['updated'],
      user_id: json['user_id']
    );
  }
}
