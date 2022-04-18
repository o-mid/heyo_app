import 'package:intl/intl.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:get/get.dart';

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String differenceFromNow() {
    DateTime now = DateTime.now();
    int diff = DateTime(year, month, day).difference(DateTime(now.year, now.month, now.day)).inDays;
    if (diff == -1) return LocaleKeys.yesterday.tr;
    if (diff == 0) return LocaleKeys.today.tr;
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
