import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/fake_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/config/colors.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/config/strings.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/pie_chart/pie_chart.dart';

class StatisticalScreen extends StatelessWidget {
  final _data = FakeRepository.data;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          translations.translate("funtion.name.statistical"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _row2by2Widget(context),
            _buildChart(context),
            _gridListItems()
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: category.map((data) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width / 20,
                        vertical: size.height / 90),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color:
                                  AppColors.pieColors[category.indexOf(data)],
                              shape: BoxShape.circle),
                        ),
                        Text(
                          data['name'],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(right: size.width / 30),
                child: PieChartWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridListItems() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: _data.length,
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.85),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 4),
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  blurRadius: 2,
                  offset: Offset(0.5, 0.5),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _data[index].serviceName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Flutter Development",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Accept Booking",
                      style: TextStyle(fontSize: 16, color: Colors.indigo),
                    ),
                    Text("Decline"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _row2by2Widget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _singleItemQuickStats(
                  context,
                  title: "Total Bookings",
                  value: "28,345",
                  width: MediaQuery.of(context).size.width / 2.6,
                  icon: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _singleItemQuickStats(
                  context,
                  title: "Pending Approval",
                  value: "180",
                  icon: null,
                  width: MediaQuery.of(context).size.width / 2.6,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _singleItemQuickStats(context,
                    title: "New Clients This Month",
                    value: "810",
                    icon: Icons.arrow_upward,
                    iconColor: Colors.green,
                    width: MediaQuery.of(context).size.width / 2.6),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _singleItemQuickStats(context,
                    title: "Returning Clients",
                    value: "20%",
                    icon: Icons.arrow_downward,
                    width: MediaQuery.of(context).size.width / 2.6,
                    iconColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _singleItemQuickStats(context,
      {String title,
      String value,
      IconData icon,
      double width,
      Color iconColor}) {
    return Container(
      width: width,
      height: 110,
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              spreadRadius: 2,
              offset: Offset(0.5, 0.5),
              blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          icon == null
              ? Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      icon,
                      color: iconColor,
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
