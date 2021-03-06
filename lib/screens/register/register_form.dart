import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/authentication_bloc/authentication_event.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/register_bloc/register_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/register_bloc/register_event.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/register_bloc/register_state.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/infonation_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/widgets/gradient_button.dart';

class RegisterForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  RegisterBloc _registerBloc;
  bool _obscureText;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
    _obscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Register',
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.isFailure) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Register Failure'),
                        Icon(Icons.error),
                      ],
                    ),
                    backgroundColor: Color(0xffffae88),
                  ),
                );
            }

            if (state.isSubmitting) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Registering...'),
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      ],
                    ),
                    backgroundColor: Color(0xffffae88),
                  ),
                );
            }

            if (state.isSuccess) {
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedIn(),
              );
              popAllAndPush(context, InfomationScreen());
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autovalidate: true,
                          autocorrect: false,
                          validator: (_) {
                            return !state.isEmailValid ? 'Invalid Email' : null;
                          },
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.key),
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            suffixIcon: IconButton(
                                icon: _obscureText
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                    () {
                                      _obscureText = !_obscureText;
                                    },
                                  );
                                }),
                          ),
                          obscureText: _obscureText,
                          autovalidate: true,
                          autocorrect: false,
                          validator: (_) {
                            return !state.isPasswordValid
                                ? 'Password has at least 6 characters!'
                                : null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GradientButton(
                          width: 150,
                          height: 45,
                          onPressed: () async {
                            if (isButtonEnabled(state)) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _onFormSubmitted();
                            }
                          },
                          text: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onEmailChange() {
    _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    _registerBloc
        .add(RegisterPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(RegisterSubmitted(
        email: _emailController.text, password: _passwordController.text));
  }

  Future popAllAndPush(BuildContext context, Widget widget) async {
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => widget),
        ModalRoute.withName('/'));
  }
}
