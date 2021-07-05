import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';

class AddProcessItem extends StatefulWidget {
  @override
  _AddProcessItemState createState() => _AddProcessItemState();
}

class _AddProcessItemState extends State<AddProcessItem> {
  bool test = true;
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
      body: SingleChildScrollView(
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
                  initialValue: DateTime.now().toString(),
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
                  onChanged: (val) => print(val),
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
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
                  initialValue: DateTime.now().toString(),
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
                  onChanged: (val) => print(val),
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text("Content"),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 8,
                      decoration: InputDecoration.collapsed(
                        hintText: "Enter your content here",
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text("Take a photo"),
              ),
              Container(
                child: !test
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(Icons.add_a_photo_rounded),
                          ),
                        ),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("assets/images/research-techniques.jpg"),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
