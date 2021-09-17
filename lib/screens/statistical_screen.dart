import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/animation/animation_route.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/notification.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/periodic_report.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/register.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/register_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/fake_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/notification_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/periodic_report_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/register_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/topic_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/main_screen/user_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/topic_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/config/colors.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/config/strings.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/pie_chart/pie_chart.dart';

import 'add_process_item.dart';

class StatisticalScreen extends StatefulWidget {
  @override
  _StatisticalScreenState createState() => _StatisticalScreenState();
}

class _StatisticalScreenState extends State<StatisticalScreen> {
  final _data = FakeRepository.data;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          translations.translate("funtion.name.statistical"),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _row2by2Widget(context),
            statistedWidget(context),
            _buildChart(context),
            _gridListItems()
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: category.map((data) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width / 20,
                        vertical: size.height / 90),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color:
                                  AppColors.pieColors[category.indexOf(data)],
                              shape: BoxShape.circle),
                        ),
                        Text(
                          data['name'],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(right: size.width / 30),
                child: PieChartWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridListItems() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: _data.length,
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.85),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 4),
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  blurRadius: 2,
                  offset: Offset(0.5, 0.5),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _data[index].serviceName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Flutter Development",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Accept Booking",
                      style: TextStyle(fontSize: 16, color: Colors.indigo),
                    ),
                    Text("Decline"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<RegisterResponse> getInfoRegister() async {
    return await RegisterRepository().getAllRegisters();
  }

  Widget _row2by2Widget(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Duyệt đề tài",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          height: 8,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text("Chủ đề"),
                flex: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 3,
                  height: 20,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Sinh viên đăng kí"),
                ),
                flex: 3,
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          color: Colors.black,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: FutureBuilder<RegisterResponse>(
              future: getInfoRegister(),
              builder: (context, AsyncSnapshot<RegisterResponse> snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }
                List<Register> registers = snapshot.data.registers
                    .where((element) => element.browseTopic == 0)
                    .toList();
                print(registers.length);
                return ListView.builder(
                  itemCount: registers.length,
                  itemBuilder: (context, int index) {
                    return buildRegisterItem(registers[index], false);
                  },
                );
              }),
        ),
        Divider(
          height: 4,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget statistedWidget(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Đề tài đã duyệt",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text("Chủ đề"),
                flex: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 3,
                  height: 20,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Sinh viên đăng kí"),
                ),
                flex: 3,
              ),
            ],
          ),
        ),
        Divider(
          height: 4,
          color: Colors.black,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: FutureBuilder<RegisterResponse>(
              future: getInfoRegister(),
              builder: (context, AsyncSnapshot<RegisterResponse> snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }
                List<Register> registers = snapshot.data.registers
                    .where((element) => element.browseTopic == 1)
                    .toList();
                print(registers.length);
                return ListView.builder(
                  itemCount: registers.length,
                  itemBuilder: (context, int index) {
                    return buildRegisterItem(registers[index], true);
                  },
                );
              }),
        ),
        Divider(
          height: 4,
          color: Colors.black,
        ),
      ],
    );
  }

  Future<Topic> getTopic(int idTopic) async {
    return await TopicRepository().getTopicById(idTopic);
  }

  Future<UserApi> getUser(String idUser) async {
    return await UserRepository().getUserApi(idUser);
  }

  Widget buildRegisterItem(Register register, bool isBrowsed) {
    Topic topic;
    UserApi userApi;
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                AnimatingRoute(
                    router: TopicScreen(
                  topic: topic,
                )));
          },
          child: Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: FutureBuilder<Topic>(
                            future: getTopic(register.idTopic),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox();
                              }
                              topic = snapshot.data;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  topic.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                      ),
                      Expanded(
                        flex: 3,
                        child: FutureBuilder<UserApi>(
                            future: getUser(register.idStudent),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox();
                              }

                              userApi = snapshot.data;

                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserScreen(
                                              isNav: false,
                                              idStudent: userApi.keyFirebase,
                                            ))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    snapshot.data.name,
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  !isBrowsed
                      ? Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  //register
                                  await RegisterRepository()
                                          .updaetRegisterBrowse(register.id)
                                      ? print("success")
                                      : print("failse");

                                  // push notification

                                  bool check = await NotificationRepository()
                                      .createNotification(Notifications(
                                    content:
                                        "Yêu cầu đề tài bạn đã được duyêt.\nĐề tài ${topic.name}",
                                    image: topic.image,
                                    idStudent: userApi.keyFirebase,
                                    timeCreated: DateTime.now().toString(),
                                  ));
                                  if (check) {
                                    print("success noti");
                                  } else {
                                    print("false noti");
                                  }

                                  //create timeline
                                  await PeriodicReportRepository()
                                          .createPeriodicReport(
                                    PeriodicReport(
                                      topicCode: topic.id.toString(),
                                      idStudent: userApi.keyFirebase,
                                      field: topic.field,
                                      content: topic.name,
                                      image: topic.image,
                                      dateStarted: DateTime.now().toString(),
                                      dateEnd: topic.acceptanceTime,
                                    ),
                                  )
                                      ? print("create timeline success")
                                      : print("create timeline false");

                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Đã duyệt đề tài"),
                                            Icon(
                                              Icons.error,
                                              color: Colors.redAccent,
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.black38,
                                      ),
                                    );
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.playlist_add,
                                        color: Colors.green),
                                    Text(
                                      "Duyệt",
                                      style: TextStyle(fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  if (await RegisterRepository()
                                      .deleteRegister(register.id)) {
                                    bool check = await NotificationRepository()
                                        .createNotification(Notifications(
                                      content:
                                          "Yêu cầu đề tài bạn đã bị từ chối.\nĐề tài ${topic.name}",
                                      image: topic.image,
                                      idStudent: userApi.keyFirebase,
                                      timeCreated: DateTime.now().toString(),
                                    ));
                                    if (check) {
                                      print("success noti");
                                    } else {
                                      print("false noti");
                                    }

                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Từ chối yêu cầu"),
                                              Icon(
                                                Icons.error,
                                                color: Colors.redAccent,
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.black38,
                                        ),
                                      );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Lỗi"),
                                              Icon(
                                                Icons.error,
                                                color: Colors.redAccent,
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.black38,
                                        ),
                                      );
                                  }
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    Text(
                                      "Từ chối",
                                      style: TextStyle(fontSize: 8),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _singleItemQuickStats(context,
      {String title,
      String value,
      IconData icon,
      double width,
      Color iconColor}) {
    return Container(
      width: width,
      height: 110,
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              spreadRadius: 2,
              offset: Offset(0.5, 0.5),
              blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          icon == null
              ? Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      icon,
                      color: iconColor,
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
