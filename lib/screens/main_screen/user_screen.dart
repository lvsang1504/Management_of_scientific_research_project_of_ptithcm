import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/image_controller.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/image_pick_and_crop/image_picker_handler.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/widget_circular_animation.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  String imageUrl;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  UserRepository userRepository;

  TextEditingController _nameController;
  TextEditingController _birthdayController;
  TextEditingController _idCardController;
  TextEditingController _phoneNumberController;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init();
    userRepository = UserRepository();

    _nameController = TextEditingController(
        text: FirebaseAuth.instance.currentUser.displayName);
    _birthdayController = TextEditingController(text: "15/04/2000");
    _idCardController = TextEditingController(text: "301733248");
    _phoneNumberController = TextEditingController(text: "0816397011");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    _nameController.dispose();
    _birthdayController.dispose();
    _idCardController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerScreen(context),
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Name',
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.edit_outlined),
                          ),
                        ),
                        controller: _nameController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Class',
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.edit_outlined),
                          ),
                        ),
                        controller: _phoneNumberController,
                        // style: TextStyle(fontSize: 18),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Birthday',
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.edit_outlined),
                          ),
                        ),
                        controller: _birthdayController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Identity Card',
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.edit_outlined),
                          ),
                        ),
                        controller: _idCardController,
                        // style: TextStyle(fontSize: 18),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Phone Number',
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.edit_outlined),
                          ),
                        ),
                        controller: _phoneNumberController,
                        // style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack headerScreen(BuildContext context) {
    UserRepository userRepository = UserRepository();
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
                                            CircularProgressIndicator(),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
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
            Text(
              FirebaseAuth.instance.currentUser.displayName ?? "User",
              style: TextStyle(fontSize: 22, color: Colors.white),
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
