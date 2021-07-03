import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/blocs/authentication_bloc/authentication_event.dart';

class SettingSwitchCubit extends Cubit<bool> {
  SettingSwitchCubit(bool state) : super(state);

  void onChangeDarkMode(bool isDark) => emit(isDark);
}
class SettingLogOutCubit extends Cubit<AuthenticationEvent> {
  SettingLogOutCubit() : super(null);
  //final UserRepository _userRepository;

  void logOut() async {
    //await _userRepository.signOut();
    emit(AuthenticationLoggedOut());
  }
}


