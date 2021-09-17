import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/image_controller.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/user_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';

import 'main_screen/timeline_screen.dart';
import 'main_screen/user_screen.dart';

class UserControllScreen extends StatefulWidget {
  @override
  _UserControllScreenState createState() => _UserControllScreenState();
}

class _UserControllScreenState extends State<UserControllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Danh sách người dùng",
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: FutureBuilder<UserResponse>(
            future: UserRepository().getUsers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }

              List<UserApi> users = snapshot.data.users;
              users = users..sort((a, b) => a.role.compareTo(b.role));
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserScreen(
                                  isNav: false,
                                  idStudent: users[index].keyFirebase,
                                ))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        elevation: 6,
                        color: Colors.white,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: FutureBuilder<String>(
                                      future: UserRepository().getPhoto(
                                          'user/${users[index].keyFirebase}'),
                                      builder:
                                          (context, AsyncSnapshot<String> img) {
                                        if (!img.hasData) return SizedBox();

                                        return CachedNetworkImage(
                                            imageUrl: img.data ?? imageUrlLogo);
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        users[index].name,
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        users[index].role == 1
                                            ? "Người dùng"
                                            : "Quản trị viên",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                users[index].role == 1
                                    ? GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TimelinePage(
                                                      id: users[index]
                                                          .keyFirebase,
                                                      isAdmin: true,
                                                    ))),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Xem tiến trình",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
