import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';

class UserResponse {
  final List<UserApi> users;
  final String error;

  UserResponse(
    this.users,
    this.error,
  );

  UserResponse.fromJson(Map<String, dynamic> json)
      : users = (json as List).map((e) => UserApi.fromJson(e)).toList(),
        error = "";
  UserResponse.withError(String error)
      : users = [],
        error = error;
}
