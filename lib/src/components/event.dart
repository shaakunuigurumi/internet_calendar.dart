part of 'package:internet_calendar/src/components.dart';

/// A [Event] calendar component is a grouping of
/// component properties, possibly including [Alarm] calendar
/// components, that represents a scheduled amount of time on a
/// calendar.
class Event extends ICalendarComponent {
  Event({
    required this.uid,
    required this.dateTimeStamp,
    required this.dateTimeStart,
    this.summary,
    this.dateTimeEnd,
    this.duration,
    this.comment,
    this.description,
    super.components = const [],
  }) : assert(
          !(dateTimeEnd != null && duration != null),
          'Cannot specify both dateTimeEnd and duration',
        );

  factory Event.parse(String input) {
    final iterator = parseLines(input).iterator..moveNext();
    return Event._fromIterator(iterator);
  }

  factory Event._fromIterator(
    Iterator<ContentLine> iterator, {
    bool strict = false,
  }) {
    var line = iterator.current;

    if (line.name != 'BEGIN' && line.value != 'VEVENT') {
      throw FormatException('Expected BEGIN:VEVENT, got $line');
    }

    late DateTime dateTimeStamp;
    late String uid;
    String? description;
    String? summary;
    late DateTime dateTimeStart;

    while (iterator.moveNext()) {
      line = iterator.current;

      switch (line.name) {
        case 'END' when line.value == 'VEVENT':
          return Event(
            dateTimeStamp: dateTimeStamp,
            uid: uid,
            summary: summary,
            description: description,
            dateTimeStart: dateTimeStart,
          );

        case 'DTSTAMP':
          dateTimeStamp = DateTime.parse(line.value);

        case 'UID':
          uid = line.value;

        case 'DESCRIPTION':
          description = line.value;

        case 'SUMMARY':
          summary = line.value;
        case 'DTSTART':
          dateTimeStart = DateTime.parse(line.value);

        default:
          if (strict) throw FormatException('Unknown property ${line.name}');
      }
    }

    throw FormatException('Expected END:VEVENT, got $line');
  }

  final String? summary;

  /// In the case of an iCalendar object that specifies a
  /// "METHOD" property, this property specifies the date and time that
  /// the instance of the iCalendar object was created.  In the case of
  /// an iCalendar object that doesn't specify a "METHOD" property, this
  /// property specifies the date and time that the information
  /// associated with the calendar component was last revised in the
  /// calendar store.
  final DateTime dateTimeStamp;

  /// This property defines the start date and time for the event.
  final DateTime dateTimeStart;

  /// This property specifies the date and time that a calendar component ends.
  final DateTime? dateTimeEnd;

  /// This property specifies a positive duration of time.
  final Duration? duration;

  /// This property defines the persistent, globally unique identifier for the
  /// calendar component.
  final String uid;

  /// This property is used to specify a comment to the calendar user.
  final List<String>? comment;

  /// This property is used to capture lengthy textual descriptions associated
  /// with the activity.
  final String? description;

  @override
  void writeTo(StringSink sink) {
    sink.writeln('BEGIN:VEVENT');

    // dtstamp
    sink
      ..write('DTSTAMP:')
      ..writeDateUtc(dateTimeStamp);

    // uid
    sink.writeln('UID:$uid');

    // dtstart
    sink
      ..write('DTSTART:')
      ..writeDateUtc(dateTimeStart);

    // description
    final description = this.description;
    if (description != null) {
      sink.writeln('DESCRIPTION:${description.replaceAll('\n', r'\n')}');
    }

    // summary
    final summary = this.summary;
    if (summary != null) {
      sink.writeln('SUMMARY:${summary.replaceAll('\n', r'\n')}');
    }

    // dtend
    final dateTimeEnd = this.dateTimeEnd;
    if (dateTimeEnd != null) {
      sink
        ..write('DTEND:')
        ..writeDateUtc(dateTimeEnd);
    }

    // duration
    if (duration != null) {
      sink.write('DURATION:$duration');
    }

    // comment
    if (comment != null) {
      for (final comment in this.comment!) {
        sink.writeln('COMMENT:${comment.replaceAll('\n', r'\n')}');
      }
    }

    sink.writeln('END:VEVENT');
  }

  @override
  int get hashCode => Object.hashAll([
        dateTimeStamp,
        dateTimeStart,
        dateTimeEnd,
        duration,
        uid,
        comment,
        description,
        summary,
      ]);

  @override
  bool operator ==(covariant Event other) {
    return super == other &&
        dateTimeStamp == other.dateTimeStamp &&
        dateTimeStart == other.dateTimeStart &&
        dateTimeEnd == other.dateTimeEnd &&
        duration == other.duration &&
        uid == other.uid &&
        comment == other.comment &&
        description == other.description &&
        summary == other.summary;
  }
}

extension on StringSink {
  void writeDateUtc(DateTime dateTime) {
    final dateTimeStampUtc = dateTime.toUtc().copyWith(microsecond: 0);

    write(dateTimeStampUtc.year.toString().padLeft(4, '0'));
    write(dateTimeStampUtc.month.toString().padLeft(2, '0'));
    write(dateTimeStampUtc.day.toString().padLeft(2, '0'));
    write('T');
    write(dateTimeStampUtc.hour.toString().padLeft(2, '0'));
    write(dateTimeStampUtc.minute.toString().padLeft(2, '0'));
    write(dateTimeStampUtc.second.toString().padLeft(2, '0'));
    write('Z');
  }
}
