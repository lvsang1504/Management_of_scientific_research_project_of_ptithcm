import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/scroll_text.dart';

class GridFunction extends StatefulWidget {
  @override
  _GridFunctionState createState() => _GridFunctionState();
}

class _GridFunctionState extends State<GridFunction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.cyanAccent.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SimpleCarousel(
            colorIconCircleBar: Colors.white,
            colorIconCircleBarActive: Colors.deepOrange,
            numberPages: 2,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ItemButton(
                    icon: Icons.app_registration,
                    title: "${translations.translate("funtion.name.register")}",
                  ),
                  ItemButton(
                    icon: Icons.approval,
                    title: "${translations.translate("funtion.name.approve")}",
                    onTap: () {},
                  ),
                  ItemButton(
                    icon: Icons.search_sharp,
                    title: "${translations.translate("funtion.name.lookupInfo")}",
                  ),
                  ItemButton(
                    icon: Icons.bar_chart_rounded,
                    title: "${translations.translate("funtion.name.statistical")}",
                    onTap: () {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ItemButton(
                    icon: Icons.group_work_outlined,
                    title: "${translations.translate("funtion.name.member")}",
                    onTap: () {},
                  ),
                  ItemButton(
                    icon: Icons.recent_actors_outlined,
                    title: "${translations.translate("funtion.name.report")}",
                  ),
                  ItemButton(
                    icon: Icons.account_box_rounded,
                    title: "${translations.translate("funtion.name.account")}",
                    onTap: () {},
                  ),
                  ItemButton(
                    icon: Icons.recent_actors_outlined,
                    title: "${translations.translate("funtion.name.account")}",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const ItemButton({
    Key key,
    this.icon,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).bottomAppBarColor.withOpacity(0.7),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            Spacer(),
            SizedBox(
              height: 15,
              width: 45,
              child: ScrollingText(
                text: title,
                textStyle: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SimpleCarousel extends StatefulWidget {
  const SimpleCarousel({
    Key key,
    @required this.numberPages,
    @required this.children,
    this.colorIconCircleBarActive,
    this.colorIconCircleBar,
  })  : assert(numberPages != null),
        assert(children != null),
        super(key: key);

  final int numberPages;

  final List<Widget> children;

  /// Default color is [Colors.grey[700]].
  final Color colorIconCircleBarActive;

  /// Default color is [Colors.grey].
  final Color colorIconCircleBar;

  @override
  _SimpleCarousel createState() => _SimpleCarousel();
}

class _SimpleCarousel extends State<SimpleCarousel> {
  PageController _controller;
  int _indexPage = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: PageView(
            key: ValueKey('PageViewKey'),
            children: widget.children,
            physics: ClampingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _indexPage = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 8,
        ),
        _buildPageIndicator(
          colorIconCircleBar: widget.colorIconCircleBar ?? Colors.grey,
          colorIconCircleBarActive:
              widget.colorIconCircleBarActive ?? Colors.grey[700],
          itemCount: widget.numberPages,
          currentPageValue: _indexPage,
        ),
      ],
    );
  }

  Widget _buildPageIndicator({
    final int currentPageValue,
    final int itemCount,
    final Color colorIconCircleBarActive,
    final Color colorIconCircleBar,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < itemCount; i++)
          if (i == currentPageValue) ...[
            _circleBar(
              key: ValueKey('circleBar$i'),
              isActive: true,
              colorIconCircleBar: colorIconCircleBar,
              colorIconCircleBarActive: colorIconCircleBarActive,
            )
          ] else
            _circleBar(
              key: ValueKey('circleBar$i'),
              isActive: false,
              colorIconCircleBar: colorIconCircleBar,
              colorIconCircleBarActive: colorIconCircleBarActive,
            ),
      ],
    );
  }

  Widget _circleBar({
    Key key,
    bool isActive,
    Color colorIconCircleBarActive,
    Color colorIconCircleBar,
  }) {
    return AnimatedContainer(
      key: key,
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? colorIconCircleBarActive : colorIconCircleBar,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
