import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/language_bloc/language_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/repositories/user_repository.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/bottom_navigation.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/login/login_screen.dart';
import 'blocs/simple_bloc_observer.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';
import 'blocs/authentication_bloc/authentication_state.dart';
import 'blocs/theme/app_theme_cubit.dart';
import 'blocs/theme/dependencies.dart';
import 'blocs/theme/theme_modes.dart';

// Dùng để chạy localhost API
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

void main() async {
  //HttpOverrides.global = new MyHttpOverrides();

  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initial language
  await translations.init('en');
  final UserRepository userRepository = UserRepository();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
            userRepository: userRepository,
          )..add(AuthenticationStarted()),
        ),
        BlocProvider(create: (context) => LanguageBloc()),
      ],
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
            );
          },
        ),
      ),
    );
  }
}
