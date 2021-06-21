import 'package:management_of_scientific_research_project_of_ptithcm/models/periodic_report_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/periodic_report_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/topic_repository.dart';
import 'package:rxdart/rxdart.dart';

class PeriodicReportsListBloc {
  final PeriodicReportRepository _repository = PeriodicReportRepository();
  final BehaviorSubject<PeriodicReportResponse> _subject = BehaviorSubject();

  getTopics(String key) async {
    PeriodicReportResponse response = await _repository.getPeriodicReports(key);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<PeriodicReportResponse> get subject => _subject;

}

final periodicReportsListBloc = PeriodicReportsListBloc();
