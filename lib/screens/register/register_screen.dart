import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/register_bloc/register_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const RegisterScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color(0xff6a515e),
        ),
      ),
      body: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: _userRepository),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.cyanAccent, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(child: SvgPicture.asset("assets/svg/register.svg", height: 150,)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  child: RegisterForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
