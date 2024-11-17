enum _State { name, paramName, paramValue, value }

typedef ContentLine = ({
  String name,
  Map<String, List<String>>? params,
  String value
});

/// Implementation of the ABNF rules for content lines from RFC 5545.
///
/// **The implementation does not exactly match the specification.**
Iterable<ContentLine> parseLines(String input) sync* {
  String? name;
  String? paramName;
  List<String>? paramValues;
  Map<String, List<String>>? params;
  bool? readingQuoted;

  var state = _State.name;

  final buffer = StringBuffer();

  for (var i = 0; i < input.length; i++) {
    var char = input[i];

    final isDigit = char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
    final isAlpha = char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90 ||
        char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122;
    final isAlphaNum = isAlpha || isDigit;
    bool isLineFeed() => char == '\n';
    bool isCarriageReturn() => char == '\r';

    switch (state) {
      case _State.name:
        if (isAlphaNum || char == '-') {
          buffer.write(char);
        } else if (char == ':' || char == ';') {
          name = buffer.toString();
          buffer.clear();

          if (char == ':') {
            state = _State.value;
          } else if (char == ';') {
            state = _State.paramName;
            params = {};
          }
        } else {
          throw FormatException(
            'Reading name, expected alpha-numeric, hyphen, semicolon, or '
            'colon, got $char',
            input,
            i,
          );
        }

      case _State.paramName:
        if (isAlphaNum || char == '-') {
          buffer.write(char);
        } else if (char == '=') {
          paramName = buffer.toString();
          buffer.clear();
          state = _State.paramValue;
          paramValues = [];
        } else {
          throw FormatException(
            'Reading parameter name, expected alpha-numeric, hyphen, or equal '
            'sign, got $char',
            input,
            i,
          );
        }

      case _State.paramValue:
        if (readingQuoted == null) {
          readingQuoted = char == '"';
          if (readingQuoted == true) continue;
        }

        if (readingQuoted == true) {
          if (char == '"') {
            readingQuoted = null;
            paramValues!.add(buffer.toString());
          } else {
            buffer.write(char);
          }
        } else if (char == ',' || char == ':') {
          if (buffer.isNotEmpty) {
            paramValues!.add(buffer.toString());
          }

          buffer.clear();

          if (char == ':') {
            state = _State.value;

            assert(params != null, 'Parameters should not be null');
            assert(paramName != null, 'Parameter name should not be null');
            assert(paramValues != null, 'Parameter values should not be null');

            params![paramName!] = paramValues!;

            paramName = null;
            paramValues = null;

            continue;
          }
        } else {
          buffer.write(char);
        }

      case _State.value:
        if (isCarriageReturn() || isLineFeed()) {
          if (isCarriageReturn()) {
            char = input[++i];

            if (isLineFeed()) {
              throw FormatException(
                'Reading value, expected CRLF, got $char',
                input,
                i,
              );
            }
          }

          // peeking for a space -- folding behavior -- don't commit yet
          if (input.length > i + 1 && input[i + 1] == ' ') {
            // there is an incoming space, so we should skip it and keep reading
            i++;
            continue;
          }

          yield (name: name!, params: params, value: buffer.toString());
          buffer.clear();

          name = null;
          params = null;

          state = _State.name;
        } else {
          buffer.write(char);
        }
    }
  }

  if (state == _State.value && buffer.isNotEmpty) {
    yield (name: name!, params: params, value: buffer.toString());
    buffer.clear();
  }
}
