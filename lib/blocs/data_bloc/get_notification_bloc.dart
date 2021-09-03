import 'package:management_of_scientific_research_project_of_ptithcm/models/notification_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/notification_repository.dart';
import 'package:rxdart/rxdart.dart';

class NotificationListBloc {
  final NotificationRepository _repository = NotificationRepository();
  final BehaviorSubject<NotificationResponse> _subject = BehaviorSubject();

  getNotifications(String idStudent) async {
    NotificationResponse response = await _repository.getNotifications(idStudent);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<NotificationResponse> get subject => _subject;
}

final notificationsBloc = NotificationListBloc();
