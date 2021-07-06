import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/login_bloc/login_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';

import 'reset_form.dart';

class ResetPasswordScreen extends StatefulWidget {
  final UserRepository userRepository;

  const ResetPasswordScreen({Key key, this.userRepository}) : super(key: key);
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(userRepository: widget.userRepository),
        child: Container(
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
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                      child: SvgPicture.asset(
                    "assets/svg/reset_pass.svg",
                    height: 150,
                  )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  child: ResetForm(
                    userRepository: widget.userRepository,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
