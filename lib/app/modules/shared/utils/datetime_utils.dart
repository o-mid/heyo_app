class DateTimeUtils {

  int getCurrentTimeInSeconds(int? addNum) {
    final ms = DateTime.now().millisecondsSinceEpoch;
    return (ms / 1000).round() + (addNum ?? 0);
  }
}
