class DateTimeWrapper {
  int nowInMillis() => DateTime.now().millisecondsSinceEpoch;
  DateTime now() => DateTime.now();
  DateTime defaultCalendarDateTime() => DateTime(
        now().year,
        now().day > 1 ? now().month : now().month - 1,
      );
}
