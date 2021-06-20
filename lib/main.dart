import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/bloc/theme/theme_state.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/bottom_navigation.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/login/login_screen.dart';
import 'bloc/simple_bloc_observer.dart';
import 'bloc/theme/app_theme_cubit.dart';
import 'bloc/theme/dependencies.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';
import 'blocs/authentication_bloc/authentication_state.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();

  //WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: buildRepositories(),
      child: BlocProvider(
        create: (context) => AppThemeCubit(context.read())..init(),
        child: BlocBuilder<AppThemeCubit, bool>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: state ? Themes.themeDark : Themes.themeLight,
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationFailure) {
                    return LoginScreen(
                      userRepository: _userRepository,
                    );
                  }
                  if (state is AuthenticationSuccess) {
                    return BottomNavigationWidget();
                  }

                  return Scaffold(
                    appBar: AppBar(),
                    body: Container(
                      child: Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).accentColor,
                      )),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
