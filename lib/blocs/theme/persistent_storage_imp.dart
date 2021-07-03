import 'package:shared_preferences/shared_preferences.dart';

import 'persistent_storage_repository.dart';

const _isDarkMode = 'isDarkMode';

class PersistentStorageImpl extends PersistentStorageRepository {
  @override
  Future<bool> isDarkMode() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getBool(_isDarkMode) ?? false;
  }

  @override
  Future<void> updateDarkMode(bool isDarkMode) async {
    final preference = await SharedPreferences.getInstance();
    return await preference.setBool(_isDarkMode, isDarkMode);
  }
  
}