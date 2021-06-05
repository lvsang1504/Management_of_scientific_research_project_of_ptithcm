
import 'package:flutter/material.dart';

import '../routers.dart';

class ThemePracticeItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  ThemePracticeItem({this.imageUrl, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color:  Color(0xffecf3f9),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500],
                offset: Offset(4,4),
                blurRadius: 15.0,
                spreadRadius: 1
            ),
            BoxShadow(
                color: Colors.white,
                offset: Offset(-4,-4),
                blurRadius: 15.0,
                spreadRadius: 1
            ),
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffecf3f9).withOpacity(0.5),
                Color(0xffecf3f9).withOpacity(0.5)
              ],
              stops: [
                0,
                1
              ]
          )
      ),
      child: Row(
        children: [

          Container(
            child: ImageIcon(
              AssetImage(imageUrl),
              size: 50,
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color:  Color(0xffecf3f9),
                boxShadow: [

                  BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(4,4),
                      blurRadius: 15,
                      spreadRadius: 1
                  ),

                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4,-4),
                      blurRadius: 15,
                      spreadRadius: 1
                  ),
                ]
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(title),
                  Text(subtitle)
                ],
              ),
            ),
          ),

          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Color(0xffecf3f9),
                    width: 3
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(4,4),
                      blurRadius: 15.0,
                      spreadRadius: 1
                  ),

                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4,-4),
                      blurRadius: 15.0,
                      spreadRadius: 1
                  ),
                ]
            ),
            margin: EdgeInsets.only(right: 20),
            child: UnconstrainedBox(
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.play_arrow, size: 30,),
                  onPressed: ()=> goToPracticeScreen(context)),
            ),
          )
        ],
      ),
    );
  }

  void goToPracticeScreen(BuildContext context){
    Navigator.pushNamed(context, ApplicationRouters.exam);
  }
}