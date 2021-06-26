import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TopicRepository {
  
  Future<TopicResponse> getTopics() async {
    try {

      final response =
          await http.get(Uri.parse('https://ptithcm.azurewebsites.net/api/topics'));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return TopicResponse.fromJson(jsonResponse);

      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return TopicResponse.withError("$error");
    }
  }

  Future<TopicResponse> getSearchTopics(String key) async {
    try {
      String uri = 'https://ptithcm.azurewebsites.net/api/topics/search=$key';

      final response =
          await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return TopicResponse.fromJson(jsonResponse);

      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return TopicResponse.withError("$error");
    }
  }
}
