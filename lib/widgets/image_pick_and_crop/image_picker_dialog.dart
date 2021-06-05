import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'image_picker_handler.dart';


// ignore: must_be_immutable
class ImagePickerDialog extends StatelessWidget {

  ImagePickerHandler _listener;
  AnimationController _controller;
  BuildContext context;

  ImagePickerDialog(this._listener, this._controller);

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity =  CurvedAnimation(
      parent:  ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition =  Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate( CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (_controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    _controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) =>  SlideTransition(
            position: _drawerDetailsPosition,
            child:  FadeTransition(
              opacity:  ReverseAnimation(_drawerContentsOpacity),
              child: this,
            ),
          ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration =  Duration(milliseconds: 200);
    return  Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    _controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return  Material(
        type: MaterialType.transparency,
        child:  Opacity(
          opacity: 1.0,
          child:  Container(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                 GestureDetector(
                  onTap: () => _listener.openCamera(),
                  child: roundedButton(
                      "Camera",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      const Color(0xFF48bfe3),
                      const Color(0xFFFFFFFF),
                      Icons.camera_alt_outlined),
                ),
                 GestureDetector(
                  onTap: () => _listener.openGallery(),
                  child: roundedButton(
                      "Gallery",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      const Color(0xFF48bfe3),
                      const Color(0xFFFFFFFF),
                      Icons.photo_library),
                ),
                const SizedBox(height: 15.0),
                 GestureDetector(
                  onTap: () => dismissDialog(),
                  child:  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: roundedButton(
                        "Cancel",
                        EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        const Color(0xFFd62828),
                        const Color(0xFFFFFFFF),
                        Icons.cancel_outlined),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor, IconData icon) {
    var loginBtn =  Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration:  BoxDecoration(
        color: bgColor,
        borderRadius:  BorderRadius.all(const Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:  Colors.white38,
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20,color: textColor,),
          SizedBox(width: 15,),
          Text(
            buttonLabel,
            style:  TextStyle(
                color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
    return loginBtn;
  }

}
