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
                    topic.image != null
                        ? CachedNetworkImage(
                            imageUrl: topic.image,
                            fit: BoxFit.cover,
                          )
                        : Image.asset("assets/images/research-techniques.jpg"),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        onTap: callback,
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