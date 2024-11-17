// ignore_for_file: public_member_api_docs

/// Partial implementation of Formal Public Identifiers (FPIs).
///
/// See also:
///
/// - <https://xml.coverpages.org/tauber-fpi.html>
library fpi;

enum OwnerIdentifier { iso, unregistered, registered }

enum TextClass {
  capacity,
  charset,
  document,
  dtd,
  elements,
  entities,
  lpd,
  nonsgml,
  notation,
  sd,
  shortref,
  subdoc,
  syntax,
  text;

  @override
  String toString() => name.toUpperCase();
}

/// Generates a "formal public identifier" for the given parameters.
///
/// For your application, only [ownerText], [description], and maybe [language]
/// are required.
///
/// This function does not validate the input. The thumb rule is to use
/// alpha-numeric characters and hyphens.
String generate({
  required String ownerText,
  required String description,
  required String? language,
  OwnerIdentifier owner = OwnerIdentifier.unregistered,
  TextClass textClass = TextClass.nonsgml,
  bool unavailable = false,
  String? version,
}) {
  final buffer = StringBuffer()
    ..write(
      switch (owner) {
        OwnerIdentifier.iso => 'iso',
          OwnerIdentifier.unregistered => '-//',
        OwnerIdentifier.registered => '+//',
      },
    )
    ..write(ownerText)
    ..write('//')
    ..write(textClass)
    ..write(' ');

  if (unavailable) buffer.write('-//');

  buffer
    ..write(description)
    ..write('//')
    ..write(language);

  if (version != null) {
    buffer
      ..write('//')
      ..write(version);
  }

  return buffer.toString();
}
