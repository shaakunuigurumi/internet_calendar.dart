part of 'package:internet_calendar/src/components.dart';

/// The [ICalendar] class is a collection of calendaring and scheduling
/// information.
class ICalendar extends ICalendarComponent {
  ICalendar({List<ICalendarComponent>? components})
      : super(components: components ?? []);

  factory ICalendar._fromIterator(
    Iterator<ContentLine> iterator, {
    required bool strict,
  }) {
    final line = iterator.current;

    if (line.name != 'BEGIN' || line.value != 'VCALENDAR') {
      throw const FormatException('Not a calendar');
    }

    final components = <ICalendarComponent>[];

    while (iterator.moveNext()) {
      final line = iterator.current;

      if (line.name == 'BEGIN') {
        final component = switch (line.value) {
          'VEVENT' => Event._fromIterator(iterator),
          _ when strict =>
            throw UnimplementedError('Unknown component ${line.value}'),
          _ => null,
        };

        if (component != null) {
          components.add(component);
        }
      }
    }

    throw const FormatException('Calendar did not end');
  }

  /// The product identifier to use when writing the iCalendar data.
  ///
  /// Use [fpi.generate] to generate a product identifier.
  static String productId = fpi.generate(
    ownerText: 'shaakunuigurumi/internet_calendar.dart',
    description: 'v0.1.0',
    language: 'EN',
  );

  Iterable<Event> get events => components.whereType<Event>();

  @override
  void writeTo(StringSink sink, {String? productId}) {
    sink
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('PRODID:${productId ?? ICalendar.productId}')
      ..writeln('VERSION:2.0');

    for (final component in components) {
      component.writeTo(sink);
    }

    sink.writeln('END:VCALENDAR');
  }

  /// Parses all iCalendar data from the given [input] synchronously.
  ///
  /// If [strict] is `true`, then the parser will throw an error if it
  /// encounters unknown data.
  static Iterable<ICalendar> parseAllSync(
    String input, {
    bool strict = false,
  }) sync* {
    final iterator = parseLines(input).iterator;

    while (iterator.moveNext()) {
      yield ICalendar._fromIterator(iterator, strict: strict);
    }
  }
}
