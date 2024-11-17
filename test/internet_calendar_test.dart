import 'package:internet_calendar/internet_calendar.dart';
import 'package:test/test.dart';

void main() {
  group('parse', () {
    test('three-day conference', () {
      final calendars = ICalendar.parseAllSync(r'''
BEGIN:VCALENDAR
PRODID:-//xyz Corp//NONSGML PDA Calendar Version 1.0//EN
VERSION:2.0
BEGIN:VEVENT
DTSTAMP:19960704T120000Z
UID:uid1@example.com
ORGANIZER:mailto:jsmith@example.com
DTSTART:19960918T143000Z
DTEND:19960920T220000Z
STATUS:CONFIRMED
CATEGORIES:CONFERENCE
SUMMARY:Networld+Interop Conference
DESCRIPTION:Networld+Interop Conference
  and Exhibit\nAtlanta World Congress Center\n
 Atlanta\, Georgia
END:VEVENT
END:VCALENDAR
      ''');

      expect(calendars, hasLength(1));

      final calendar = calendars.first;
      expect(calendar.components, hasLength(1));

      final component = calendar.components.first;
      expect(component, isA<Event>());

      calendars.join('\n');
    });
  });
}
