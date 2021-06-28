import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class UsersListBloc {
  final UserRepository _repository = UserRepository();
  final BehaviorSubject<UserApi> _subject = BehaviorSubject();

  getUsers(String firebaseKey) async {
    UserApi response = await _repository.getUserApi(firebaseKey);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<UserApi> get subject => _subject;

}

final usersBloc = UsersListBloc();
