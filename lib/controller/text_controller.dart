enum AppText{
  titleLanguage,
  setting,
  fontSize,
  darkMode,
  soundSetting,
}

/// Title, text
const Map<AppText, String> textKey ={
  // will replace to Key in sqlite;
  AppText.titleLanguage:"Ngôn ngữ",
  AppText.fontSize : "Kích thước chữ",
  AppText.darkMode: "Chế độ ban đêm",
  AppText.soundSetting: "Cài đặt âm thanh",
  AppText.setting: "Cài đặt"
};

extension getText on AppText{
  static String getStringValue(String value){
    if(textKey == null) return "";

    for (AppTextEntry appText in _texts) {
      if (appText.title == value && appText.text.trim().length > 0) {
        return appText.text.trim();
      }
    }

    return value;

  }



  static List<AppTextEntry> _texts;

  // static init(String languageCode) async {
  //   _texts = await MainDBProvider.db.getAppTexts(languageCode);
  // }


  // will replace text from local db
  String get text => textKey[this];
}
class AppTextEntry {
  String title;
  String text;

  AppTextEntry({this.title, this.text});

  factory AppTextEntry.fromMap(
      Map<String, dynamic> json, String languageCode) =>
      new AppTextEntry(title: json["id"], text: json[languageCode]??json["id"]);
}