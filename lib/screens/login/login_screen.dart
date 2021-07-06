
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/login_bloc/login_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const LoginScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body:  Container(
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.cyanAccent, Colors.white],
          )),
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Center(child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SvgPicture.asset("assets/svg/login.svg", height: 150,),
                )),
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  child: LoginForm(userRepository: _userRepository,),
                )
              ],
            ),
          ),
        ),
      
    );
  }
}
