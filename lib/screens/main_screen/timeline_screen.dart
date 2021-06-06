import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/data_timeline.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/timeline_model.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/timline.dart';

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

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      timelineModel(TimelinePosition.Left),
      timelineModel(TimelinePosition.Center),
      timelineModel(TimelinePosition.Right)
    ];

    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Timeline",
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
              onTap: () {},
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
                  text: "Left",
                ),
                Tab(
                  text: "Center",
                ),
                Tab(
                  text: "Right",
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: pages,
      ),
    );
  }

  Widget timelineModel(TimelinePosition position) => Timeline.builder(
      lineColor: Theme.of(context).accentColor,
      itemBuilder: centerTimelineBuilder,
      itemCount: doodles.length,
      physics: position == TimelinePosition.Left
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = doodles[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(doodle.doodle),
                const SizedBox(
                  height: 8.0,
                ),
                Text(doodle.time, style: textTheme.caption),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  doodle.name,
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
        onTap: (){print(doodle.time);},
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == doodles.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }
}
