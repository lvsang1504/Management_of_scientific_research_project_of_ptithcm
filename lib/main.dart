import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/language_bloc/language_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/onboarding_screen.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/login_bloc/login_bloc.dart';
import 'blocs/simple_bloc_observer.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';
import 'blocs/theme/app_theme_cubit.dart';
import 'blocs/theme/dependencies.dart';
import 'blocs/theme/theme_modes.dart';

// Dùng để chạy localhost API
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
int initScreen;

void main() async {
  //Dùng để chạy localhost
  HttpOverrides.global =  MyHttpOverrides();

  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initial language is english
  await translations.init('en');
  final UserRepository userRepository = UserRepository();
  //Read initScreen, if initScreen == 0 orr initScreen  == null => first time init
  // initScreen == 1 set to 1 to indicate it has initialized
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');
  //////////////////////////////////////////////////////////////////////////////////
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
            userRepository: userRepository,
          )..add(AuthenticationStarted()),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(userRepository: userRepository),
        ),
        BlocProvider(create: (context) => LanguageBloc()),
      ],
      child: MyApp(
        userRepository: userRepository,
        initScreen: initScreen,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final int initScreen;

  MyApp({UserRepository userRepository, this.initScreen})
      : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: buildRepositories(),
      child: BlocProvider(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: BlocProvider(
          create: (context) => AppThemeCubit(context.read())..init(),
          child: BlocBuilder<AppThemeCubit, bool>(
            builder: (context, theme) {
              return BlocBuilder<LanguageBloc, String>(
                bloc: BlocProvider.of<LanguageBloc>(context),
                builder: (context, lang) {
                  return MaterialApp(
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate
                    ],
                    supportedLocales: translations.supportedLocales(),
                    debugShowCheckedModeBanner: false,
                    locale: Locale(lang, ''),
                    title: 'Management Scientific Research PTITHCM',
                    theme: theme ? Themes.themeDark : Themes.themeLight,
                    initialRoute:
                        initScreen == 0 || initScreen == null ? "first" : "/",
                    routes: {
                      '/': (context) => SplashScreen(
                            userRepository: _userRepository,
                          ),
                      "first": (context) => OnboardingScreen(
                            userRepository: _userRepository,
                          ),
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
