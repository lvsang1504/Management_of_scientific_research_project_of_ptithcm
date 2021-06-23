import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/topic_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/topic_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/home_list_view.dart';

class SearchScreen extends StatefulWidget {
  final String keySearch;

  const SearchScreen({Key key, this.keySearch}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController searchController = TextEditingController();
  List<Topic> topics = [];

  Future<TopicResponse> getData(String key) async {
    var topicResponse =
        await TopicRepository().getSearchTopics(searchController.text);
    return topicResponse;
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    searchController.text = widget.keySearch;
    getData(searchController.text);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Container(
              height: 60,
              child: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.grey.withOpacity(0.5),
                actions: [
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 8, top: 8, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100].withOpacity(0.3),
                        borderRadius: BorderRadius.all(
                          Radius.circular(38),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 4, bottom: 4),
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(38.0)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                         
                          setState(() {});
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
            ),
            Expanded(
              child: Container(
                child: FutureBuilder<TopicResponse>(
                  future: getData(searchController.text),
                  builder: (BuildContext context,
                      AsyncSnapshot<TopicResponse> snapshot) {
                    final spinkit = SpinKitCircle(
                      color: Colors.cyan,
                      size: 50.0,
                      controller: AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 1200)),
                    );

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
                      topics = snapshot.data.topics;
                      if (topics.isEmpty) {
                        return Center(
                          child: Text("Not Found!"),
                        );
                      }

                      return ListView.builder(
                        itemCount: topics.length,
                        itemBuilder: (context, int index) {
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(CurvedAnimation(
                            parent: animationController,
                            curve: Interval((1 / topics.length) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ));
                          animationController.forward();
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: HomeListView(
                              isGridView: false,
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
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
