import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';

class TopicListView extends StatelessWidget {
  const TopicListView({
    Key key,
    this.topic,
    this.callback,
    this.animationController,
    this.animation,
    this.isGridView,
  }) : super(key: key);

  final Topic topic;
  final VoidCallback callback;
  final AnimationController animationController;
  final Animation animation;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: isGridView
                    ? buildGridView(context)
                    : buildListView(context),
              ),
            ),
          ),
        );
      },
    );
  }

  GestureDetector buildGridView(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Card(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: topic.image != null
                  ? CachedNetworkImage(
                      imageUrl: topic.image,
                    )
                  : Image.asset("assets/images/research-techniques.jpg"),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "${topic.name}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListView(context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: callback,
      child: Card(
        elevation: 5,
        color: Theme.of(context).cardColor,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: size.width * 0.16,
                        height: size.width * 0.16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.teal[300], width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: topic.image != null
                              ? CachedNetworkImage(
                                  imageUrl: topic.image,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/research-techniques.jpg"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Text(
                        "${translations.translate("screen.topic.id")}: ${topic.topicCode}",
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "${topic.name}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "${topic.content}",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Text(
                      "${translations.translate("discovery")}",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.double_arrow_outlined,
                        color: Colors.redAccent),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
