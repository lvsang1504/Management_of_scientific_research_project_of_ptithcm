import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/topic.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({
    Key key,
    this.topic,
    this.callback,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final Topic topic;
  final VoidCallback callback;
  final AnimationController animationController;
  final Animation animation;

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
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          child: topic.image != null
                              ? CachedNetworkImage(
                                  imageUrl: topic.image,
                                )
                              : Image.asset(
                                  "assets/images/research-techniques.jpg"),
                          onTap: callback,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${topic.content}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
