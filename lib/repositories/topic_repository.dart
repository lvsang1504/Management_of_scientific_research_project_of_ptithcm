import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TopicRepository {

   Future<bool> createTopic(Topic topic) async {
    try {
      print(convert.jsonEncode(topic.toJson()));
      final response = await http.post(
        Uri.parse('https://10.0.2.2:5001/api/topics/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(topic.toJson()),
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
  
  Future<TopicResponse> getTopics() async {
    try {
      //https://ptithcm.azurewebsites.net/api/topics
      // final response =
      //     await http.get(Uri.parse('https://ptithcm.azurewebsites.net/api/topics'));
      final response =
          await http.get(Uri.parse('https://10.0.2.2:5001/api/topics'));

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

  Future<Topic> getTopicById(int id) async {
    try {
      final response = await http.get(Uri.parse(
          'https://10.0.2.2:5001/api/topics/$id'));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return Topic.fromJson(jsonResponse);
      } else if(response.statusCode == 404){
        print("Not found!");
      }
      else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<TopicResponse> getSearchTopics(String key) async {
    try {
      String uri = 'https://10.0.2.2:5001/api/topics/search=$key';

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
