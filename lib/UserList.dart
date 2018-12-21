import 'User.dart';
/**
* The UserList class converts a json file into a list of User Objects
*/
class UserList {
  final List<User> users;

  UserList(
      {this.users});
  /**
  * The UserList.fromJson method converts a json file of Users into a list of User Objects.
  */
  factory UserList.fromJson(List<dynamic> parsedJson) {
    List<User> users = new List<User>();
    users = parsedJson.map((i)=>User.fromJson(i)).toList();
    return new UserList(
      users: users,
    );
  }
}
