import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/authentication_bloc/authentication_state.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';

import 'bottom_navigation.dart';
import 'login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  final UserRepository userRepository;

  const SplashScreen({Key key, this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationFailure) {
                      return LoginScreen(
                        userRepository: userRepository,
                      );
                    }
                    if (state is AuthenticationSuccess) {
                      return BottomNavigationWidget();
                    }

                    return Container(
                      color: Colors.cyanAccent,
                      child: Center(child: Image.asset("assets/logo/logo.png")),
                    );
                  },
                ))));

    var assetsImage = AssetImage("assets/logo/logo.png");
    var image = Image(image: assetsImage, height: 300);
    GlobalKey _scaffoldKey = GlobalKey();
    return MaterialApp(
        home: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.cyanAccent,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      child: image,
                    ),
                    Text(
                      "PTIT Scientific Research",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${translations.translate("wellcome")}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            // body: Stack(
            //   fit: StackFit.expand,
            //   children: <Widget>[
            //     Container(
            //       decoration:  BoxDecoration(color: Colors.cyanAccent),
            //     ),
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: <Widget>[
            //         Expanded(
            //           flex: 2,
            //           child: Container(
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: <Widget>[
            //                  CircleAvatar(
            //                   backgroundColor: Colors.white,
            //                   radius: 50.0,
            //                   child: image,
            //                 ),
            //                 Padding(
            //                   padding: EdgeInsets.only(top: 10.0),
            //                 ),
            //                  Text(
            //                   "PTIT Scientific Research",
            //                   style:  TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 24.0,
            //                       fontWeight: FontWeight.bold),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //         Expanded(
            //           flex: 1,
            //           child:  Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: <Widget>[
            //               CircularProgressIndicator(),
            //               Padding(
            //                 padding: EdgeInsets.only(top: 24.0),
            //               ),
            //  Text(
            //   "Welcome",
            //   style:  TextStyle(
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18.0,
            //   ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // ),
            ));
  }
}
