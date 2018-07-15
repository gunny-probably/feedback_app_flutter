import 'dart:core';

class DateTimeSimple extends DateTime {
  DateTimeSimple(int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0
  ]) : super(year, month, day, hour, minute, second, millisecond, microsecond);

  /* mugged */
  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  /* mugged */
  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  @override
  String toString() {
    String y = _fourDigits(year);
    String m = _twoDigits(month);
    String d = _twoDigits(day);
    return "$y-$m-$d";
  }
}