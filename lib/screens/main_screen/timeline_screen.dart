import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/animation/animation_route.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/periodic_report_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/periodic_report_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/timeline_model.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/timline.dart';

import '../add_process_item.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage>
    with TickerProviderStateMixin {
  final PageController pageController =
      PageController(initialPage: 1, keepPage: true);
  int pageIx = 1;

  int idTopic=0;

  Future<PeriodicReportResponse> getData(String key) async {
    var periodicReportResponse =
        await PeriodicReportRepository().getPeriodicReports(key);
    return periodicReportResponse;
  }

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    getData(FirebaseAuth.instance.currentUser.uid);

    final spinkit = SpinKitCircle(
      color: Colors.cyan,
      size: 50.0,
      duration: const Duration(milliseconds: 1200),
      // controller: AnimationController(
      //     vsync: this, duration: const Duration(milliseconds: 1200)),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: DrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${translations.translate("screen.process")}',
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Icon(Icons.add),
              onTap: () => Navigator.push(
                  context, AnimatingRoute(router: AddProcessItem(idTopic: idTopic,))),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(30.0, 30.0),
          child: Container(
            padding: EdgeInsets.only(bottom: 2),
            height: 30,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.transparent,
              labelColor: Theme.of(context).primaryColorDark,
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColorLight,
              ),
              controller: _tabController,
              tabs: [
                Tab(
                  text: "${translations.translate("screen.process.left")}",
                ),
                Tab(
                  text: "${translations.translate("screen.process.center")}",
                ),
                Tab(
                  text: "${translations.translate("screen.process.right")}",
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<PeriodicReportResponse>(
          future: getData(FirebaseAuth.instance.currentUser.uid),
          builder: (context, AsyncSnapshot<PeriodicReportResponse> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: SizedBox(
                height: 70,
                child: Column(
                  children: [
                    spinkit,
                    Spacer(),
                    Text('${translations.translate("loading")}'),
                  ],
                ),
              ));
              //timelineModel(TimelinePosition.Right, snapshot.data);
            }

            

            idTopic  =  int.parse(snapshot.data.periodicReports[0].topicCode);

            if (snapshot.data.periodicReports.length == 0) {
              return Center(
                child: Text(
                  "Bạn chưa đăng kí đề tài nào.",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return TabBarView(
              controller: _tabController,
              children: [
                timelineModel(TimelinePosition.Left, snapshot.data),
                timelineModel(TimelinePosition.Center, snapshot.data),
                timelineModel(TimelinePosition.Right, snapshot.data),
              ],
            );
          }),
    );
  }

  Widget timelineModel(
          TimelinePosition position, PeriodicReportResponse reportResponse) =>
      Timeline.builder(
        lineColor: Theme.of(context).accentColor,
        itemCount: reportResponse.periodicReports.length,
        physics: position == TimelinePosition.Left
            ? ClampingScrollPhysics()
            : BouncingScrollPhysics(),
        position: position,
        itemBuilder: (BuildContext context, int i) {
          //final doodle = doodles[i];
          final reportResponses = reportResponse.periodicReports[i];
          final textTheme = Theme.of(context).textTheme;

          return TimelineModel(
            Padding(
              padding: i == reportResponse.periodicReports.length - 1
                  ? const EdgeInsets.only(bottom: 80)
                  : const EdgeInsets.only(bottom: 0),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CachedNetworkImage(
                          imageUrl: reportResponses.image ??
                              "https://www.google.com/logos/doodles/2015/abu-al-wafa-al-buzjanis-1075th-birthday-5436382608621568-hp2x.jpg"),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(reportResponses.dateStarted ?? "sad",
                          style: textTheme.caption),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        reportResponses.content,
                        style: textTheme.title,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              print(reportResponses.dateStarted ?? "sad");
            },
            position: i % 2 == 0
                ? TimelineItemPosition.right
                : TimelineItemPosition.left,
            isFirst: i == 0,
            isLast: i == reportResponse.periodicReports.length,
            iconBackground: i == 0
                ? Colors.redAccent
                : i == reportResponse.periodicReports.length - 1
                    ? Colors.amber
                    : Colors.teal,
            icon: i == 0
                ? Icon(Icons.star)
                : i == reportResponse.periodicReports.length - 1
                    ? Icon(Icons.approval)
                    : Icon(Icons.account_tree_rounded),
          );
        },
      );

  //TimelineModel centerTimelineBuilder
}
