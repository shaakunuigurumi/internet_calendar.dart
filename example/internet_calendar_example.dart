// ignore_for_file: avoid_print

import 'package:internet_calendar/internet_calendar.dart';

void main() {
  // create a calendar
  final calendar = ICalendar();

  // create an event
  const duration = Duration(days: 7);
  final dateTime = DateTime.now();

  final event = Event(
    uid: 'atashi@yahoo.co.jp',
    dateTimeStamp: dateTime,
    dateTimeStart: dateTime,
    dateTimeEnd: dateTime.add(duration),
    summary: 'Buy an IKEA blue shark',
    description: 'shork.',
  );

  // add your event to the calendar
  calendar.components.add(event);

  // print the calendar
  print(calendar);

  // - or -

  // parse an iCalendar string
  final calendars = ICalendar.parseAllSync('''
BEGIN:VCALENDAR
PRODID:-//shaakunuigurumi/internet_calendar.dart//NONSGML v0.1.0//EN
VERSION:2.0
BEGIN:VEVENT
DTSTAMP:20241117T082348Z
UID:atashi@yahoo.co.jp
DTSTART:20241117T082348Z
DESCRIPTION:shork.
SUMMARY:Buy an IKEA blue shark
DTEND:20241117T082348Z
END:VEVENT
END:VCALENDAR
  ''');

  for (final calendar in calendars) {
    for (final component in calendar.components) {
      if (component is Event) {
        print(component.summary);
      }
    }
  }

  // it's that easy! ⭐
}
