import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/data_bloc/get_topics_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/hotel_list_data.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_reponse.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/search_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/topic_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/home_list_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

int countFound;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController searchController = TextEditingController();
  bool multiple = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    topicsBloc.getTopics();
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    topicsBloc.getTopics();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      body: Stack(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: [
                Expanded(
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Column(
                              children: [
                                getSearchBarUI(),
                                GridFunction(),
                              ],
                            );
                          }, childCount: 1),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: ContestTabHeader(
                            getFilterBarUI(
                              title: "${countFound ?? ""} topics found",
                            ),
                          ),
                        ),
                      ];
                    },
                    body: buildTopics(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopics() {
    final spinkit = SpinKitCircle(
      color: Colors.cyan,
      size: 50.0,
      controller: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1200)),
    );
    return FutureBuilder<bool>(
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return FutureBuilder<Object>(
              future: Future.delayed(Duration(seconds: 5)),
              builder: (context, snapshot) {
                topicsBloc.getTopics();
                return SizedBox();
              });
        } else {
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder<TopicResponse>(
                    stream: topicsBloc.subject.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<TopicResponse> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: SizedBox(
                          height: 70,
                          child: Column(
                            children: [
                              spinkit,
                              Spacer(),
                              Text("Loading..."),
                            ],
                          ),
                        ));
                      } else {
                        List<Topic> topics = snapshot.data.topics;

                        return SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = Text("Pull up load");
                              } else if (mode == LoadStatus.loading) {
                                body = CircularProgressIndicator();
                              } else if (mode == LoadStatus.failed) {
                                body = Text("Load Failed! Click retry!");
                              } else if (mode == LoadStatus.canLoading) {
                                body = Text("Release to load more");
                              } else {
                                body = Text("No more data");
                              }
                              return Container(
                                height: 55.0,
                                child: Center(child: body),
                              );
                            },
                          ),
                          child: GridView(
                            padding: const EdgeInsets.only(
                                top: 0, left: 12, right: 12),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            children:
                                List<Widget>.generate(topics.length, (index) {
                              countFound = topics.length;
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / countFound) * index, 1.0,
                                    curve: Curves.fastOutSlowIn),
                              ));
                              animationController.forward();
                              return HomeListView(
                                animation: animation,
                                animationController: animationController,
                                topic: topics[index],
                                callback: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                FadeTransition(
                                                    opacity: animation1,
                                                    child: TopicScreen(
                                                      topic: topics[index],
                                                    ))),
                                  );
                                },
                              );
                            }),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: multiple ? 2 : 1,
                              mainAxisSpacing: 12.0,
                              crossAxisSpacing: 12.0,
                              childAspectRatio: 1.5,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget getFilterBarUI({String title}) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            color: Theme.of(context).buttonColor.withOpacity(0.5),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$title',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                multiple = !multiple;
                              });
                            },
                            child: multiple
                                ? Icon(
                                    Icons.dashboard,
                                    color: Theme.of(context).accentColor,
                                  )
                                : Icon(
                                    Icons.view_agenda,
                                    color: Theme.of(context).accentColor,
                                  ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.filter_list_outlined,
                                color: Theme.of(context).accentColor,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget getSearchBarUI() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 8, top: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[100].withOpacity(0.3),
                borderRadius: BorderRadius.all(
                  Radius.circular(38),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                child: TextField(
                  controller: searchController,
                  onChanged: (String txt) {},
                  style: const TextStyle(fontSize: 18),
                  //cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Typing...',
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(38.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  return Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          FadeTransition(
                        opacity: animation1,
                        child: SearchScreen(
                          keySearch: searchController.text,
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    FontAwesomeIcons.search,
                    size: 20,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        "Home",
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      iconTheme: IconThemeData(
        color: Theme.of(context).accentColor,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        IconButton(icon: Icon(Icons.info_outline), onPressed: () {}),
      ],
    );
  }
}

class ItemButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const ItemButton({
    Key key,
    this.icon,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              Spacer(),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class GridFunction extends StatefulWidget {
  @override
  _GridFunctionState createState() => _GridFunctionState();
}

class _GridFunctionState extends State<GridFunction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.cyanAccent.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SimpleCarousel(
            colorIconCircleBar: Colors.white,
            colorIconCircleBarActive: Colors.deepOrange,
            numberPages: 2,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ItemButton(
                    icon: Icons.handyman,
                    title: "dsaf",
                    onTap: () {},
                  ),
                  ItemButton(
                    icon: Icons.handyman,
                    title: "dsaf",
                  ),
                  ItemButton(
                    icon: Icons.handyman,
                    title: "dsaf",
                    onTap: () {},
                  ),
                  ItemButton(
                    icon: Icons.hail,
                    title: "dsc",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ItemButton(
                    icon: Icons.handyman,
                    title: "dsaf",
                    onTap: () {},
                  ),
                  ItemButton(
                    icon: Icons.hail,
                    title: "dsc",
                  ),
                  ItemButton(
                    icon: Icons.handyman,
                    title: "dsaf",
                    onTap: () {},
                  ),
                  ItemButton(
                    icon: Icons.hail,
                    title: "dsc",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Import that the parent widget has a size.
class SimpleCarousel extends StatefulWidget {
  const SimpleCarousel({
    Key key,
    @required this.numberPages,
    @required this.children,
    this.colorIconCircleBarActive,
    this.colorIconCircleBar,
  })  : assert(numberPages != null),
        assert(children != null),
        super(key: key);

  final int numberPages;

  final List<Widget> children;

  /// Default color is [Colors.grey[700]].
  final Color colorIconCircleBarActive;

  /// Default color is [Colors.grey].
  final Color colorIconCircleBar;

  @override
  _SimpleCarousel createState() => _SimpleCarousel();
}

class _SimpleCarousel extends State<SimpleCarousel> {
  PageController _controller;
  int _indexPage = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: PageView(
            key: ValueKey('PageViewKey'),
            children: widget.children,
            physics: ClampingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _indexPage = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 8,
        ),
        _buildPageIndicator(
          colorIconCircleBar: widget.colorIconCircleBar ?? Colors.grey,
          colorIconCircleBarActive:
              widget.colorIconCircleBarActive ?? Colors.grey[700],
          itemCount: widget.numberPages,
          currentPageValue: _indexPage,
        ),
      ],
    );
  }

  Widget _buildPageIndicator({
    final int currentPageValue,
    final int itemCount,
    final Color colorIconCircleBarActive,
    final Color colorIconCircleBar,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < itemCount; i++)
          if (i == currentPageValue) ...[
            _circleBar(
              key: ValueKey('circleBar$i'),
              isActive: true,
              colorIconCircleBar: colorIconCircleBar,
              colorIconCircleBarActive: colorIconCircleBarActive,
            )
          ] else
            _circleBar(
              key: ValueKey('circleBar$i'),
              isActive: false,
              colorIconCircleBar: colorIconCircleBar,
              colorIconCircleBarActive: colorIconCircleBarActive,
            ),
      ],
    );
  }

  Widget _circleBar({
    Key key,
    bool isActive,
    Color colorIconCircleBarActive,
    Color colorIconCircleBar,
  }) {
    return AnimatedContainer(
      key: key,
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? colorIconCircleBarActive : colorIconCircleBar,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
