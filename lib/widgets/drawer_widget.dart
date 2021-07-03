import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/animation/animation_route.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/authentication_bloc/authentication_event.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/language_bloc/language_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/theme/app_theme_cubit.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/theme/setting_cubit.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/image_controller.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/setting_screen/font_size_setting_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/setting_screen/language_screen.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  UserRepository userRepository = UserRepository();
  getAvatar() async {
    return await userRepository
        .getPhoto('user/${FirebaseAuth.instance.currentUser.uid}');
  }

  Future<UserApi> getData() async {
    var user = await UserRepository()
        .getUserApi(FirebaseAuth.instance.currentUser.uid);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final _langBloc = BlocProvider.of<LanguageBloc>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors
            .transparent, // set the Color of the drawer transparent; we'll paint above it with the shape
      ),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Drawer(
          elevation: 0.0,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CustomPaint(
              painter: DrawerPainter(
                color: Theme.of(context).cardColor,
              ), // this is your custom painter
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: FutureBuilder(
                              future: getAvatar(),
                              builder: (context, snapshot) {
                                return Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: snapshot.data != null
                                        ? CachedNetworkImage(
                                            imageUrl: snapshot.data.toString(),
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(
                                              backgroundColor: Colors.blueGrey,
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: imageUrlLogo,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(
                                              backgroundColor: Colors.blueGrey,
                                            ),
                                          ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        FutureBuilder<UserApi>(
                            future: getData(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text(
                                  "${FirebaseAuth.instance.currentUser.displayName ?? "${translations.translate("screen.user")}"}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).appBarTheme.color,
                                  ),
                                );
                              } else
                                return Text(
                                  "${snapshot.data.name ?? "${translations.translate("screen.user")}"}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).appBarTheme.color,
                                  ),
                                );
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 100),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.font_download_outlined),
                          SizedBox(
                            width: 12,
                          ),
                          Text('${translations.translate("setting.font")}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            AnimatingRoute(router: FontSizeSettingScreen()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 100),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.language_outlined),
                          SizedBox(
                            width: 12,
                          ),
                          Text('${translations.translate("setting.language")}'),
                          Spacer(),
                          Container(
                            height: 32,
                            child: translations.currentLanguage == "en"
                                ? Image.asset(
                                    "assets/images/united-kingdom.png",
                                  )
                                : Image.asset("assets/images/vietnam.png"),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context, AnimatingRoute(router: LanguageScreen()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 100),
                    child: BlocProvider(
                      create: (context) => SettingSwitchCubit(
                          context.read<AppThemeCubit>().isDark),
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(Icons.nights_stay_rounded),
                            Text(
                                '${translations.translate("setting.darkMode")}'),
                            SizedBox(
                              width: 12,
                            ),
                            BlocBuilder<SettingSwitchCubit, bool>(
                              builder: (context, state) {
                                return Switch(
                                  value: state,
                                  onChanged: (val) {
                                    context
                                        .read<SettingSwitchCubit>()
                                        .onChangeDarkMode(val);
                                    context
                                        .read<AppThemeCubit>()
                                        .updateTheme(val);
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 100),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 12,
                          ),
                          Text('${translations.translate("setting.logout")}'),
                        ],
                      ),
                      onTap: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(AuthenticationLoggedOut());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget Drawer(BuildContext context) {

//   return ;
// }

// Class which draws the custom shape
class DrawerPainter extends CustomPainter {
  final Color color;
  DrawerPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;
    canvas.drawPath(getShapePath(size.width, size.height), paint);
  }

  // This is the path of the shape we want to draw
  Path getShapePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x / 2, 0)
      ..quadraticBezierTo(x, y / 2, x / 2, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(DrawerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
