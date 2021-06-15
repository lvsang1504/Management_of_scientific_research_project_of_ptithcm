import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_reponse.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/topic_repository.dart';
import 'package:rxdart/rxdart.dart';

class TopicsListBloc {
  final TopicRepository _repository = TopicRepository();
  final BehaviorSubject<TopicResponse> _subject = BehaviorSubject();

  getTopics() async {
    TopicResponse response = await _repository.getTopics();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<TopicResponse> get subject => _subject;

}

final topicsBloc = TopicsListBloc();
