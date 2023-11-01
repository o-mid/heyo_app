import 'package:intl/intl.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:get/get.dart';

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String differenceFromNow() {
    DateTime now = DateTime.now();
    int diff = DateTime(year, month, day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff == -1) return LocaleKeys.yesterday.tr;
    if (diff == 0) return LocaleKeys.today.tr;
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String dateInAmPmFormat() {
    return DateFormat('yyyy-MM-dd, hh:mm a').format(this);
  }

  String formattedDifference(DateTime? endTime) {
    if (endTime == null) {
      return DateFormat('yyyy-MM-dd, hh:mm a').format(this);
    }

    final difference = endTime.difference(this);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    if (hours == 0) {
      return '$minutes minutes';
    } else if (minutes == 0) {
      return '$hours hours';
    } else {
      return '$hours hours and $minutes minutes';
    }
  }
}
