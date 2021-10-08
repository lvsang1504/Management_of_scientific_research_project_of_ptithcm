import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/animation/animation_route.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/image_controller.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/splash_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/image_pick_and_crop/image_picker_handler.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/widget_circular_animation.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class InfomationScreen extends StatefulWidget {
  @override
  _InfomationScreenState createState() => _InfomationScreenState();
}

class _InfomationScreenState extends State<InfomationScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idStudentController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int _value = 1;

  ImagePickerHandler imagePicker;
  String imageUrl;
  AnimationController _controller;
  UserRepository userRepository;

  final _btnSaveController = RoundedLoadingButtonController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    if (isValidInfo()) {
      final userApi = UserApi(
        role: _value,
        email: FirebaseAuth.instance.currentUser.email,
        name: _nameController.text.trim().toUpperCase(),
        classRoom: _classController.text.trim().toUpperCase(),
        idStudent: _idStudentController.text.trim().toUpperCase(),
        phone: _phoneController.text.trim(),
        keyFirebase: FirebaseAuth.instance.currentUser.uid,
      );
      if (await UserRepository().createUser(userApi)) {
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
        Timer(Duration(milliseconds: 1200), () {
          Navigator.pushReplacement(
              context, AnimatingRoute(router: SplashScreen()));
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
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init();

    userRepository = UserRepository();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    _nameController.dispose();
    _idStudentController.dispose();
    _classController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  getAvatar() async {
    return await userRepository
        .getPhoto('user/${FirebaseAuth.instance.currentUser.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  "YOUR INFOMATION",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 150,
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (_) => _btnSaveController.reset(),
                        controller: _nameController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.perm_identity),
                          labelText: "Name",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (valid) {
                          return valid.trim().isEmpty
                              ? "Name cannot be blank!"
                              : null;
                        },
                      ),
                      TextFormField(
                        onChanged: (_) => _btnSaveController.reset(),
                        controller: _idStudentController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.code_rounded),
                          labelText: "ID Student",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (valid) {
                          return valid.trim().isEmpty
                              ? "Id Student cannot be blank!"
                              : null;
                        },
                      ),
                      TextFormField(
                        onChanged: (_) => _btnSaveController.reset(),
                        controller: _classController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.grade),
                          labelText: "Class",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (valid) {
                          return valid.trim().isEmpty
                              ? "Class cannot be blank!"
                              : null;
                        },
                      ),
                      TextFormField(
                          onChanged: (_) => _btnSaveController.reset(),
                          controller: _phoneController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.phone),
                            labelText: "Phone Number",
                          ),
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (valid) {
                            return valid.trim().isEmpty
                                ? "Phone number cannot be blank!"
                                : null;
                          }),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: "Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autovalidate: true,
                        autocorrect: false,
                        enabled: false,
                        initialValue:
                            FirebaseAuth.instance.currentUser.email ?? "null",
                      ),
                      SizedBox(height: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Bạn là: ",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Sinh Viên',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.blueAccent),
                            ),
                            leading: Radio(
                              value: 1,
                              groupValue: _value,
                              onChanged: (int value) {
                                setState(() {
                                  _value = value;
                                  print(_value);
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Giảng Viên',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.blueAccent),
                            ),
                            leading: Radio(
                              value: 2,
                              groupValue: _value,
                              onChanged: (int value) {
                                setState(() {
                                  _value = value;
                                  print(_value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: RoundedLoadingButton(
                            width: 100,
                            color: Colors.cyan,
                            successColor: Colors.greenAccent,
                            child: Text('Save',
                                style: TextStyle(color: Colors.white)),
                            controller: _btnSaveController,
                            onPressed: _onSaveInfo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  userImage(File _image) async {
    imageUrl = await userRepository.uploadPhoto(
        _image, 'user/${FirebaseAuth.instance.currentUser.uid}');
    setState(() {});
  }
}
