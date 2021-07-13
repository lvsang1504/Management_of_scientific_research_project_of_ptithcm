import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/utils/styles.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String version = "0.0.1";
    final String email = "n18dccn172@student.ptithcm.edu.vn";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          translations.translate("setting.aboutus"),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                child: Image.asset(
                  "assets/logo/logo.png",
                  height: 100,
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Text("Version:    $version", style: kTitleStyle,),
              ),
            ),
            Divider(height: 2,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Text("Contact us: $email", style: kTitleStyle,),
              ),
            ),
            Divider(height: 2,),
          ],
        ),
      ),
    );
  }
}
