import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/data_bloc/get_user_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/image_controller.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/image_pick_and_crop/image_picker_handler.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/widget_circular_animation.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  String imageUrl;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  UserRepository userRepository = UserRepository();

  TextEditingController _nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser.displayName ?? "");
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _idStudentController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  final _btnSaveController = RoundedLoadingButtonController();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init();

    usersBloc.getUsers(FirebaseAuth.instance.currentUser.uid ?? "");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _idStudentController.dispose();
    _classController.dispose();
    super.dispose();
  }

  bool isValidInfo() {
    if (checkInfo(_nameController.text, "Name is required.") &&
        checkInfo(_idStudentController.text, "ID Student is required.") &&
        checkInfo(_classController.text, "Class name is required.") &&
        checkInfo(_phoneController.text, "Phone number is required.")) {
      return true;
    }
    return false;
  }

  bool checkInfo(String key, String notify) {
    if (key.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$notify'),
                Icon(Icons.error_rounded, color: Colors.redAccent)
              ],
            ),
            backgroundColor: Colors.black12,
          ),
        );
      return false;
    } else {
      return true;
    }
  }

  void _onSaveInfo() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (isValidInfo()) {
      final userApi = UserApi(
        email: FirebaseAuth.instance.currentUser.email,
        name: _nameController.text.trim().toUpperCase(),
        classRoom: _classController.text.trim().toUpperCase(),
        idStudent: _idStudentController.text.trim().toUpperCase(),
        phone: _phoneController.text.trim(),
        keyFirebase: FirebaseAuth.instance.currentUser.uid,
        role: 1,
      );
      if (await UserRepository()
          .updateUser(userApi, userApi.keyFirebase.trim())) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Saved.'),
                  Icon(
                    Icons.check,
                    color: Colors.greenAccent,
                  )
                ],
              ),
              backgroundColor: Color(0xffffae88),
            ),
          );
        _btnSaveController.success();
        setState(() {
          usersBloc.getUsers(FirebaseAuth.instance.currentUser.uid ?? "");
        });
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Error! Try again.'),
                  Icon(
                    Icons.error,
                    color: Colors.redAccent,
                  )
                ],
              ),
              backgroundColor: Color(0xffffae88),
            ),
          );
        _btnSaveController.reset();
      }
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Error! Try again.'),
                Icon(
                  Icons.error,
                  color: Colors.redAccent,
                )
              ],
            ),
            backgroundColor: Color(0xffffae88),
          ),
        );
      _btnSaveController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 50),
          child: SizedBox(
            height: 50,
            width: 70,
            child: RoundedLoadingButton(
              //width: 70,
              height: 40,
              color: Colors.blue,
              successColor: Colors.greenAccent,
              child: Text('Save', style: TextStyle(color: Colors.white)),
              controller: _btnSaveController,
              onPressed: _onSaveInfo,
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerScreen(context),
            StreamBuilder<UserApi>(
                stream: usersBloc.subject.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          children: [
                            SpinKitCircle(
                              color: Colors.cyan,
                              size: 50.0,
                              controller: AnimationController(
                                  vsync: this,
                                  duration: const Duration(milliseconds: 1200)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Loading..."),
                          ],
                        ),
                      ),
                    );
                  } else {
                    UserApi user = snapshot.data;
                    _nameController.text = user.name;
                    _idStudentController.text = user.idStudent;
                    _classController.text = user.classRoom;
                    _phoneController.text = user.phone;
                    return Form(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (_) => _btnSaveController.reset(),
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  icon: Icon(Icons.perm_identity),
                                  labelText: "Name",
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (valid) {
                                  return valid.trim().isEmpty
                                      ? "Name cannot be blank!"
                                      : null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (_) => _btnSaveController.reset(),
                                controller: _idStudentController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  icon: Icon(Icons.code_rounded),
                                  labelText: "ID Student",
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (valid) {
                                  return valid.trim().isEmpty
                                      ? "Id Student cannot be blank!"
                                      : null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (_) => _btnSaveController.reset(),
                                controller: _classController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  icon: Icon(Icons.grade),
                                  labelText: "Class",
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (valid) {
                                  return valid.trim().isEmpty
                                      ? "Class cannot be blank!"
                                      : null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  onChanged: (_) => _btnSaveController.reset(),
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    icon: Icon(Icons.phone),
                                    labelText: "Phone Number",
                                  ),
                                  keyboardType: TextInputType.phone,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (valid) {
                                    return valid.trim().isEmpty
                                        ? "Phone number cannot be blank!"
                                        : null;
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  icon: Icon(Icons.email),
                                  labelText: "Email",
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autovalidate: true,
                                autocorrect: false,
                                enabled: false,
                                initialValue:
                                    FirebaseAuth.instance.currentUser.email ??
                                        "null",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Future<UserApi> getData(String firebaseKey) async {
    var userApi = await UserRepository().getUserApi(firebaseKey);
    return userApi;
  }

  Stack headerScreen(BuildContext context) {
    //UserRepository userRepository = UserRepository();
    getAvatar() async {
      return await userRepository
          .getPhoto('user/${FirebaseAuth.instance.currentUser.uid}');
    }

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.6),
                Colors.cyan.withOpacity(0.6)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          height: 60,
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => print("click edit"),
              ),
            ],
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 200,
              child: WidgetCircularAnimator(
                size: 150,
                innerIconsSize: 3,
                outerIconsSize: 3,
                innerAnimation: Curves.bounceIn,
                outerAnimation: Curves.bounceIn,
                innerColor: Colors.cyan,
                reverse: false,
                outerColor: Colors.cyanAccent,
                innerAnimationSeconds: 10,
                outerAnimationSeconds: 15,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[200]),
                  child: Stack(
                    children: [
                      FutureBuilder(
                          future: getAvatar(),
                          builder: (context, snapshot) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: snapshot.data == null
                                  ? CircleAvatar(
                                      radius: 60,
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrlLogo,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          backgroundColor: Colors.blueGrey,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          backgroundColor: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                            );
                          }),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                            onTap: () => imagePicker.showDialog(context),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 18,
                                color: Colors.white54,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FutureBuilder<UserApi>(
                future: getData(FirebaseAuth.instance.currentUser.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  } else {
                    var user = snapshot.data;
                    return Text(
                      user.name ?? "User",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    );
                  }
                }),
            SizedBox(
              height: 5,
            ),
            Text(
              FirebaseAuth.instance.currentUser.email ?? "",
              style: TextStyle(fontSize: 14, color: Colors.white38),
            ),
          ],
        ),
      ],
    );
  }

  @override
  userImage(File _image) async {
    imageUrl = await userRepository.uploadPhoto(
        _image, 'user/${FirebaseAuth.instance.currentUser.uid}');
    setState(() {});
  }
}
