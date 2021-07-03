import 'package:intl/intl.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/controller/translations.dart';

class TimeAgo {
  static String timeAgoSinceDate(DateTime notificationDate,
      {bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return DateFormat('dd-MM-yyy – kk:mm').format(notificationDate);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? "${translations.translate("time.1weekago")}" : "${translations.translate("time.weekago")}";
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} "${translations.translate("time.dayago")}"';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? "${translations.translate("time.1dayago")}" : "${translations.translate("time.yesterday")}";
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} "${translations.translate("time.hoursago")}"';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? "${translations.translate("time.1hourago")}" : "${translations.translate("time.1hourago")}";
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} "${translations.translate("time.minuteago")}"';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? "${translations.translate("time.1minuteago")}" : "${translations.translate("time.1minuteago")}";
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} "${translations.translate("time.secondsago")}"';
    } else {
      return "${translations.translate("time.justnow")}";
    }
  }
}
