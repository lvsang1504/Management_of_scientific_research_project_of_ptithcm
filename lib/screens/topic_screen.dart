import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/theme/app_theme_cubit.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/theme/setting_cubit.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/notification.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/register.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/notification_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/register_repository.dart';

class TopicScreen extends StatefulWidget {
  final Topic topic;

  TopicScreen({
    Key key,
    @required this.topic,
  }) : super(key: key);

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final formatCurrency = new NumberFormat("#,##0", "vi_VN");

  Future<Register> getInfoRegister(String idStudent) async {
    return await RegisterRepository().getRegisterStudentId(idStudent);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Register>(
        future: getInfoRegister(FirebaseAuth.instance.currentUser.uid),
        builder: (context, AsyncSnapshot<Register> snapshot) {
          return Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  print("Click Join Now");

                  if (!snapshot.hasData) {
                    if (await RegisterRepository().registerTopic(Register(
                        idTopic: widget.topic.id,
                        idStudent: FirebaseAuth.instance.currentUser.uid,
                        role: 1,
                        browseTopic: 0))) {

                          bool check = await NotificationRepository()
                                .createNotification(Notifications(
                              content:
                                  "Bạn đã yêu cầu đề tài ${widget.topic.name}",
                              image: widget.topic.image,
                              idStudent: FirebaseAuth.instance.currentUser.uid,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Đã gửi yêu cầu, chờ admin duyệt đề tài"),
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
                       bool check = await NotificationRepository()
                                .createNotification(Notifications(
                              content:
                                  "Bạn đã hủy yêu cầu đề tài ${widget.topic.name}",
                              image: widget.topic.image,
                              idStudent: FirebaseAuth.instance.currentUser.uid,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  } else if (snapshot.data.browseTopic == 0 &&
                      snapshot.data.idTopic == widget.topic.id) {
                    if (await RegisterRepository()
                        .deleteRegister(snapshot.data.id)) {
                      

                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Đã xóa yêu cầu!"),
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
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.amber.withOpacity(0.8),
                  ),
                  child: Container(
                    child: !snapshot.hasData
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "${translations.translate("screen.topic.btnJoin")}",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : snapshot.data.idTopic == widget.topic.id
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  child: snapshot.data.browseTopic == 0
                                      ? Text(
                                          "Đợi duyệt hoặc nhấn để hủy",
                                          style: TextStyle(fontSize: 18),
                                        )
                                      : Text(
                                          "Đã đăng ký đề tài",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                ),
                              )
                            : SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child:
                              CachedNetworkImage(imageUrl: widget.topic.image),
                        ),
                      ),
                      Container(
                        height: 60,
                        child: AppBar(
                          elevation: 0.0,
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          actions: [
                            BlocProvider(
                              create: (context) => SettingSwitchCubit(
                                  context.read<AppThemeCubit>().isDark),
                              child: BlocBuilder<SettingSwitchCubit, bool>(
                                builder: (context, state) {
                                  return IconButton(
                                    icon: state
                                        ? Icon(Icons.brightness_5_outlined)
                                        : Icon(Icons.brightness_3),
                                    onPressed: () {
                                      state = !state;
                                      context
                                          .read<SettingSwitchCubit>()
                                          .onChangeDarkMode(state);
                                      context
                                          .read<AppThemeCubit>()
                                          .updateTheme(state);
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${translations.translate("screen.topic.id")}: ${widget.topic.topicCode}",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          widget.topic.name.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.cyan,
                              ),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                              "${translations.translate("screen.topic.type")}: ${widget.topic.type}"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.cyan,
                              ),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                              "${translations.translate("screen.topic.field")}: ${widget.topic.field}"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${translations.translate("screen.topic.dayCreate")}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(widget.topic.dateCreated.substring(0, 10)),
                          ],
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Text(
                              "${translations.translate("screen.topic.endDate")}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(widget.topic.acceptanceTime.substring(0, 10)),
                          ],
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Text(
                              "${translations.translate("screen.topic.budget")}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                '${formatCurrency.format(widget.topic.budget)} vnd'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Text(
                        "${translations.translate("screen.topic.content")}: ${widget.topic.content}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
