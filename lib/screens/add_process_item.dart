import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/periodic_report.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/periodic_report_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/topic_repository.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddProcessItem extends StatefulWidget {
  final int idTopic;

  const AddProcessItem({Key key, this.idTopic = 0}) : super(key: key);
  @override
  _AddProcessItemState createState() => _AddProcessItemState();
}

class _AddProcessItemState extends State<AddProcessItem> {
  final TextEditingController _linkImageController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String started = "";
  String ended = "";

  final _btnSaveController = RoundedLoadingButtonController();

  @override
  void dispose() {
    _linkImageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${translations.translate("screen.process.additem")}',
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
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () => print("Click save"),
                child: Text(
                  '${translations.translate("save")}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<Topic>(
          future: TopicRepository().getTopicById(widget.idTopic),
          builder: (context, AsyncSnapshot<Topic> snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text("From"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: '${translations.translate("time.date")}',
                        timeLabelText: '${translations.translate("time.hour")}',
                        selectableDayPredicate: (date) {
                          // Disable weekend days to select from the calendar
                          if (date.weekday == 6 || date.weekday == 7) {
                            return false;
                          }

                          return true;
                        },
                        onChanged: (val) => started = val,
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => started = val,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text("To"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: '${translations.translate("time.date")}',
                        timeLabelText: '${translations.translate("time.hour")}',
                        selectableDayPredicate: (date) {
                          // Disable weekend days to select from the calendar
                          if (date.weekday == 6 || date.weekday == 7) {
                            return false;
                          }

                          return true;
                        },
                        onChanged: (val) => ended = val,
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => ended = val,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text("Content"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _contentController,
                            maxLines: 8,
                            decoration: InputDecoration.collapsed(
                              hintText: "Enter your content here",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[500],
                                offset: const Offset(4, 4),
                                blurRadius: 15.0,
                                spreadRadius: 1),
                            const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4, -4),
                                blurRadius: 15.0,
                                spreadRadius: 1),
                          ],
                        ),
                        child: TextField(
                          controller: _linkImageController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: "Nhập link hình ảnh",
                          ),
                        ),
                      ),
                    )),
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
                          onPressed: () async {
                            Topic topic = snapshot.data;
                            print(started);
                            print(_contentController.text);
                            print(_linkImageController.text);
                            if (started.isNotEmpty &&
                                ended.isNotEmpty &&
                                _contentController.text.isNotEmpty &&
                                _linkImageController.text.isNotEmpty) {
                              if (await PeriodicReportRepository()
                                  .createPeriodicReport(PeriodicReport(
                                topicCode: topic.id.toString(),
                                idStudent:
                                    FirebaseAuth.instance.currentUser.uid,
                                field: topic.field,
                                content: _contentController.text,
                                image: _linkImageController.text,
                                dateStarted: started,
                                dateEnd: ended,
                              ))) {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                  Navigator.pop(context);
                                });
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              'Vui lòng điền đầy đủ thông tin'),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _onSaveInfo(Topic topic) async {}
}
