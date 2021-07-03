import 'package:flutter/material.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/language_bloc/language_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    print(translations.currentLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final _langBloc = BlocProvider.of<LanguageBloc>(context);

    return Scaffold(
        body: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            "${translations.translate("setting.language.selectlanguage")}",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 120, top: 120),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await translations.setNewLanguage("en");
                      _langBloc.add(LANGUAGES.EN);
                      Navigator.pop(context);

                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: translations.currentLanguage == "en"
                                ? Border.all(color: Colors.cyan, width: 3) : null,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child:
                              Image.asset("assets/images/united-kingdom.png"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("${translations.translate("lang.name.en")}"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await translations.setNewLanguage("vi");
                      _langBloc.add(LANGUAGES.VI);
                      Navigator.pop(context);

                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: translations.currentLanguage == "vi"
                                ? Border.all(color: Colors.cyan, width: 3) : null,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: Image.asset("assets/images/vietnam.png"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("${translations.translate("lang.name.vi")}"),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
