import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/data_bloc/get_notification_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/image_controller.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/notification.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/notification_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/notification_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/simple_drop_down_widget.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/time_ago.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    notificationsBloc.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final spinkit = SpinKitCircle(
      color: Colors.cyan,
      size: 50.0,
      controller: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1200)),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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
        body: StreamBuilder<NotificationResponse>(
            stream: notificationsBloc.subject.stream,
            builder: (BuildContext context,
                AsyncSnapshot<NotificationResponse> snapshot) {
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
                List<Notifications> notifications = snapshot.data.notifications;
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, int index) {
                    DateTime date =
                        DateTime.parse(notifications[index].timeCreated);
                    // return NotifyItem(
                    //   size: size,
                    //   image: item.image,
                    //   title: item.content,
                    //   callback:(){},
                    //   timeCreated: TimeAgo.timeAgoSinceDate(date),
                    //   isRead: item.isRead,
                    // );
                    return buldNotifyItem(
                      size: size,
                      notifications: notifications[index],
                      callback: () {},
                    );
                  },
                );
              }
            }),
      ),
    );
  }

  Widget buldNotifyItem(
      {Size size, Notifications notifications, VoidCallback callback}) {
    DateTime date = DateTime.parse(notifications.timeCreated);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: size.height * 0.15,
      child: GestureDetector(
        onTap: callback,
        child: Card(
          elevation: notifications.isRead ? 0.0 : 2.0,
          color: notifications.isRead
              ? Theme.of(context).backgroundColor
              : Theme.of(context).cardColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: notifications.image == null
                          ? NetworkImage(imageUrlApp)
                          : NetworkImage(notifications.image),
                      radius: 40,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                        ),
                        child: Icon(
                          Icons.notifications_active,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notifications.content,
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        TimeAgo.timeAgoSinceDate(date),
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              SimpleAccountMenu(
                icons: [
                  Icon(FontAwesomeIcons.envelopeOpen),
                  Icon(Icons.delete),
                ],
                onChange: (index) async {
                  if (index == 0) {
                    bool check = await NotificationRepository()
                        .updateIsRead(true, notifications.id);
                    if (check) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Mark is read'),
                                Icon(Icons.mark_email_read, color: Colors.white,),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Something wrong. Try again!'),
                                Icon(Icons.error, color: Colors.redAccent,),
                              ],
                            ),
                            backgroundColor: Colors.black38,
                          ),
                        );
                    }

                    notificationsBloc.getNotifications();
                  } else if (index == 1) {
                    bool check = await NotificationRepository()
                        .deleteNotification(true, notifications.id);
                    if (check) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Deleted'),
                                Icon(Icons.delete_forever, color: Colors.white,),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Something wrong. Try again!'),
                                Icon(Icons.error, color: Colors.redAccent,),
                              ],
                            ),
                            backgroundColor: Colors.black38,
                          ),
                        );
                    }
                    notificationsBloc.getNotifications();
                  }
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
