part of 'package:internet_calendar/src/components.dart';

sealed class ICalendarComponent {
  const ICalendarComponent({required this.components});

  final List<ICalendarComponent> components;

  /// Writes the component to the [sink].
  void writeTo(StringSink sink);

  @override
  String toString() {
    final buffer = StringBuffer();
    writeTo(buffer);
    return buffer.toString();
  }
}
