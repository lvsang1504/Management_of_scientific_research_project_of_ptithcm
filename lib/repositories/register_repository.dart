import 'package:management_of_scientific_research_project_of_ptithcm/models/register.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/register_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RegisterRepository {
  Future<RegisterResponse> getAllRegisters() async {
    try {
      //https://ptithcm.azurewebsites.net/api/topics
      // final response =
      //     await http.get(Uri.parse('https://ptithcm.azurewebsites.net/api/topics'));
      final response =
          await http.get(Uri.parse('https://10.0.2.2:5001/api/registers'));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return RegisterResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RegisterResponse.withError("$error");
    }
  }

  Future<RegisterResponse> getRegistersSearch(String key) async {
    try {
      String uri = 'https://10.0.2.2:5001/api/registers/search=$key';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return RegisterResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RegisterResponse.withError("$error");
    }
  }

  Future<Register> getRegisterStudentId(String idStudent) async {
    try {
      final response = await http.get(Uri.parse(
          'https://10.0.2.2:5001/api/registers/firebaseKey=$idStudent'));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return Register.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        print("Not found!");
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<bool> registerTopic(Register register) async {
    try {
      print(convert.jsonEncode(register.toJson()));
      final response = await http.post(
        Uri.parse('https://10.0.2.2:5001/api/registers/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(register.toJson()),
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
  

   Future<bool> updaetRegisterBrowse(int id) async {
    final response = await http.patch(
      Uri.parse('https://10.0.2.2:5001/api/registers/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode([
        {"op": "replace", "path": "/browseTopic", "value": 1}
      ]),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<bool> deleteRegister(int id) async {
    print(id);
    final response =
        await http.delete(Uri.parse('https://10.0.2.2:5001/api/registers/$id'));
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to create album.');
    }
  }
}
