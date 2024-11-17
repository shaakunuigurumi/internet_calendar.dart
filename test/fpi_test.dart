// ignore_for_file: avoid_redundant_argument_values

import 'package:internet_calendar/fpi.dart';
import 'package:test/test.dart';

void main() {
  test('-//hacksw/handcal//NONSGML v1.0//EN', () {
    expect(
      generate(
        owner: OwnerIdentifier.unregistered,
        ownerText: 'hacksw/handcal',
        textClass: TextClass.nonsgml,
        description: 'v1.0',
        language: 'EN',
      ),
      '-//hacksw/handcal//NONSGML v1.0//EN',
    );
  });
}
