import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/data_bloc/get_topics_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/register.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/register_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/topic_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/infonation_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/search_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/topic_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/grid_function.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/topic_list_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

int countFound;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController animationController;

  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController searchController = TextEditingController();
  bool multiple = false;
  ////
  void setPermissionUser(int role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("permission", role);
    print('permission: $role');
  }

  Future<int> gettPermissionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getInt("permission");
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 0));
    return true;
  }

  Future<UserApi> getUser(String firebaseKey) async {
    var userApi = await UserRepository().getUserApi(firebaseKey);
    return userApi;
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
    return FutureBuilder<UserApi>(
        future: getUser(FirebaseAuth.instance.currentUser.uid),
        builder: (context, user) {
          if (user.connectionState == ConnectionState.done) {
            if (user.data == null) {
              return Container(
                color: Colors.white24,
                child: AlertDialog(
                  content: Container(
                    width: 260.0,
                    height: 230.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: const Color(0xFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                translations.translate("dialog.infomation"),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.info_outline,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InfomationScreen())),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF33b17c),
                              ),
                              child: Text(
                                translations
                                    .translate("dialog.infomation.button"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              setPermissionUser(user.data.role);
            }
          }

          Future<Register> getInfoRegister(String idStudent) async {
            return await RegisterRepository().getRegisterStudentId(idStudent);
          }

          return Scaffold(
            appBar: buildAppBar(context),
            drawer: DrawerWidget(),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getSearchBarUI(),
                                      FutureBuilder<int>(
                                          future: gettPermissionUser(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return CircularProgressIndicator();
                                            }

                                            return snapshot.data == 0
                                                ? GridFunction()
                                                : Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Text(
                                                          "HELLO, ${user.hasData ? user.data.name.split(" ").last : ""}",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      FutureBuilder<Register>(
                                                          future: getInfoRegister(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  .uid),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      Register>
                                                                  register) {
                                                            if (!register
                                                                .hasData) {
                                                              return SizedBox();
                                                            }
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                FutureBuilder<
                                                                        Topic>(
                                                                    future: TopicRepository().getTopicById(
                                                                        register
                                                                            .data
                                                                            .idTopic),
                                                                    builder: (context,
                                                                        AsyncSnapshot<Topic>
                                                                            topic) {
                                                                      if (!topic
                                                                          .hasData) {
                                                                        return SizedBox();
                                                                      }
                                                                      return Container(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Divider(),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                              child: register.data.browseTopic == 1 && register.data.browseTopic != -1
                                                                                  ? Text(
                                                                                      "Đề tài đã đăng ký: ",
                                                                                      style: TextStyle(color: Colors.redAccent),
                                                                                    )
                                                                                  : Text(
                                                                                      "Đề tài đang chờ được duyệt: ",
                                                                                      style: TextStyle(color: Colors.redAccent),
                                                                                    ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                "${topic.data.name}",
                                                                                style: TextStyle(fontWeight: FontWeight.w400),
                                                                              ),
                                                                            ),
                                                                            Divider(),
                                                                            GestureDetector(
                                                                              onTap: () => Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => TopicScreen(
                                                                                            topic: topic.data,
                                                                                          ))),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Đến đề tài",
                                                                                      style: TextStyle(color: Colors.redAccent),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Icon(
                                                                                      Icons.exit_to_app,
                                                                                      color: Colors.redAccent,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                              ],
                                                            );
                                                          }),
                                                    ],
                                                  );
                                          }),
                                    ],
                                  );
                                }, childCount: 1),
                              ),
                              SliverPersistentHeader(
                                pinned: true,
                                floating: true,
                                delegate: ContestTabHeader(
                                  getFilterBarUI(
                                    title:
                                        "${countFound ?? ""} ${translations.translate("screen.home.topicsFound")}",
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
        });
  }

  Widget buildTopics() {
    final spinkit = SpinKitCircle(
      color: Colors.cyan,
      size: 50.0,
      controller: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1200)),
    );
    topicsBloc.getTopics();
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
                              Text("${translations.translate("loading")}"),
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
                              return TopicListView(
                                isGridView: multiple,
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
                          // SizedBox(width: 8),
                          // GestureDetector(
                          //     onTap: () {},
                          //     child: Icon(
                          //       Icons.filter_list_outlined,
                          //       color: Theme.of(context).accentColor,
                          //     )),
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
                    hintText:
                        "${translations.translate("screen.home.hintText")}",
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
        translations.translate("screen.home"),
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
