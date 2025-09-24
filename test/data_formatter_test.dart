import 'package:eventmanagement/screens/eventchatscreen/data_formatter.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('formatDate', () {
    test('formats valid date correctly', () {
      String result = formatDate("2025-09-17");
      expect(result, "17-09-2025");
    });

    test('formats another valid date correctly', () {
      String result = formatDate("2024-01-01");
      expect(result, "01-01-2024");
    });

    test('throws error for invalid date', () {
      expect(() => formatDate("invalid-date"), throwsException);
    });
  });
}
