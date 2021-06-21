import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/data_bloc/get_topics_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();
    topicsBloc.getTopics();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: buildDrawer(context),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Notifications",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: StreamBuilder<TopicResponse>(
          stream: topicsBloc.subject.stream,
          builder: (context, AsyncSnapshot<TopicResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return Container(child: Center(child: Text("Error"),),);
              } else {
                return Container(child: Center(child: Text("${snapshot.data.topics[0].name}"),),);
              }
            } else if (snapshot.hasError) {
              return Container(child: Center(child: Text("Error"),),);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
