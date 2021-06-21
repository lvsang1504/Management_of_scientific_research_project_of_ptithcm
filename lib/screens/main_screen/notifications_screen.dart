import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/data_bloc/get_topics_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic_response.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/drawer_widget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    topicsBloc.getTopics();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: buildDrawer(context),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Notifications",
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
        ),
        body: ListView(
          children: [
            NotifyItem(size: size),
            NotifyItem(size: size),
            NotifyItem(size: size),
          ],
        ),
      ),
    );
  }
}

class NotifyItem extends StatelessWidget {
  const NotifyItem({
    Key key,
    @required this.size,
    this.title,
    this.image,
    this.callback,
  }) : super(key: key);

  final String title;
  final String image;
  final VoidCallback callback;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: size.height * 0.15,
      child: GestureDetector(
        onTap: callback,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/images/research-techniques.jpg",
                    height: size.height * 0.06,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Liên quan đến Euro năm nay, nhiều cư dân mạng Việt Nam phát sốt khi thấy hình ảnh hơn 60 ngàn cổ động viên Hungary tràn ngập trên khán đài sân vận động Puskas Arena",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.more_horiz),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
