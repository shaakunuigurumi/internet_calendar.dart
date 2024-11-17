A Dart package for iCalendar (RFC 5545).

## Features

- Parsing and writing events

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart
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

// parse an iCalendar stream
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

// print all events
for (final calendar in calendars) {
    for (final component in calendar.components) {
        if (component is Event) {
          print(component.summary);
        }
    }
}

// it's that easy! ⭐
```
