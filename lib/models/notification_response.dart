
import 'package:management_of_scientific_research_project_of_ptithcm/models/notification.dart';

class NotificationResponse {
  final List<Notifications> notifications;
  final String error;

  NotificationResponse(
    this.notifications,
    this.error,
  );

  NotificationResponse.fromJson(List<dynamic> json)
      : notifications = json.map((e) => Notifications.fromJson(e)).toList(),
        error = "";
  NotificationResponse.withError(String error)
      : notifications = [],
        error = error;
}
