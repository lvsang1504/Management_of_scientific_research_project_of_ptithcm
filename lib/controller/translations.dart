import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = "multi_language_app_";
const List<String> _supportedLanguages = ['en' ,'vi'];
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class GlobalTranslations {
  Locale _locale;
  static Map<dynamic , dynamic> _localizedValues;

  supportedLocales() => _supportedLanguages.map<Locale>((lang) => new Locale(lang , ''));

  String translate(String key) {
    return (_localizedValues == null || _localizedValues[key] == null) ? '** $key not found' : _localizedValues[key];
  }

  Map<String, dynamic> translateObject(String objectKey){
    return (_localizedValues == null || _localizedValues[objectKey] == null) ? '** $objectKey not found' : _localizedValues[objectKey];
  }

  get currentLanguage => _locale == null ? '' : _locale.languageCode;

  get locale => _locale;

  Future init(String defaultLanguage) async {
    if(_locale == null) {
      String language = await _getApplicationSavedInformation('currentLanguage');
      await setNewLanguage(language == '' ? defaultLanguage : language);
    }
  }


  Future<String> _getApplicationSavedInformation(String name) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKey + name ) ?? '';
  }

  Future<bool> _setApplicationSavedInformation(String name , String value) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKey + name  , value);
  }

  Future setNewLanguage(String newLanguage) async {

    _locale = Locale(newLanguage,"");

    String jsonContent = await rootBundle.loadString("assets/languages/${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    await _setApplicationSavedInformation("currentLanguage", newLanguage);
  }

  static final GlobalTranslations _translations = new GlobalTranslations._internal();

  factory GlobalTranslations() {
    return  _translations;
  }

  GlobalTranslations._internal();
}


GlobalTranslations translations = new GlobalTranslations();