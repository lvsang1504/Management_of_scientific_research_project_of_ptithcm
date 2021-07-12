import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/config/colors.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/config/size.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/config/strings.dart';

import 'pie_chart_custom_painter.dart';

class PieChartWidget extends StatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  double total = 0;
  @override
  void initState() {
    super.initState();
    category.forEach((e) => total += e['amount']);
  }

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    double fontSize(double size) {
      return size * width / 414;
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              shape: BoxShape.circle,
              boxShadow: AppColors.neumorpShadow),
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: constraint.maxWidth * 0.6,
                  child: CustomPaint(
                    child: Center(),
                    foregroundPainter: PieChartCustomPainter(
                        width: constraint.maxWidth * 0.5, categories: category),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: constraint.maxWidth * .4,
                  decoration: BoxDecoration(
                      color: AppColors.primaryWhite,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.neumorpShadow),
                  child: Center(
                      child: Text(
                    "\$" + total.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: fontSize(17)),
                  )),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
