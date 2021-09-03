import 'package:management_of_scientific_research_project_of_ptithcm/models/notification.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/notification_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NotificationRepository {

  Future<bool> createNotification(Notifications notifications) async {
    try {
      final response = await http.post(
        Uri.parse('https://10.0.2.2:5001/api/notifications/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(notifications.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<NotificationResponse> getNotifications(String id) async {
    try {
      final response = await http.get(Uri.parse(
          'https://10.0.2.2:5001/api/notifications/idStudent=$id'));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return NotificationResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return NotificationResponse.withError("$error");
    }
  }

  Future<bool> updateIsRead(bool isRead, int id) async {
    final response = await http.patch(
      Uri.parse('https://10.0.2.2:5001/api/notifications/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode([
        {"op": "replace", "path": "/isRead", "value": isRead}
      ]),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<bool> deleteNotification(bool isDelete, int id) async {
    final response = await http.patch(
      Uri.parse('https://10.0.2.2:5001/api/notifications/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode([
        {"op": "replace", "path": "/isDelete", "value": isDelete}
      ]),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to create album.');
    }
  }
}
