import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';

class TopicResponse {
  final List<Topic> topics;
  final String error;

  TopicResponse(
    this.topics,
    this.error,
  );

  TopicResponse.fromJson(List<dynamic> json)
      : topics = json.map((e) => Topic.fromJson(e)).toList(),
        error = "";
  TopicResponse.withError(String error)
      : topics = [],
        error = error;
}
