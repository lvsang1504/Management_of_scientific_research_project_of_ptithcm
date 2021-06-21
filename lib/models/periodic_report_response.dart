import 'package:management_of_scientific_research_project_of_ptithcm/models/periodic_report.dart';

class PeriodicReportResponse {
  final List<PeriodicReport> periodicReports;
  final String error;

  PeriodicReportResponse(
    this.periodicReports,
    this.error,
  );

  PeriodicReportResponse.fromJson(List<dynamic> json)
      : periodicReports = json.map((e) => PeriodicReport.fromJson(e)).toList(),
        error = "";

  PeriodicReportResponse.withError(String error)
      : periodicReports = [],
        error = error;
}
