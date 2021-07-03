import 'package:flutter_bloc/flutter_bloc.dart';

enum LANGUAGES { VI, EN }

class LanguageBloc extends Bloc<LANGUAGES, String> {
  LanguageBloc() : super('en');

  @override
  Stream<String> mapEventToState(LANGUAGES event) async* {
    switch (event) {
      case LANGUAGES.VI:
        yield 'vi';
        break;
      case LANGUAGES.EN:
        yield 'en';
        break;
    }
  }
}
