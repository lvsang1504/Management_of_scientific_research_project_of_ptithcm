import 'package:shared_preferences/shared_preferences.dart';

class DataLocal {
  Future<int> getPermissionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("permission");
  }
}