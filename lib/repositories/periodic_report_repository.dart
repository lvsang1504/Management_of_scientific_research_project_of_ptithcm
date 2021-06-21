import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:management_of_scientific_research_project_of_ptithcm/models/periodic_report_response.dart';

class PeriodicReportRepository {
  Future<PeriodicReportResponse> getPeriodicReports(String key) async {
    try {
      final response =
          await http.get(Uri.parse('https://10.0.2.2:5001/api/periodic-report/idStudent=N18DCCN123'));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return PeriodicReportResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PeriodicReportResponse.withError("$error");
    }
  }
}
