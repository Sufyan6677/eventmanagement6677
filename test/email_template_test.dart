import 'package:eventmanagement/widgets/email_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Template Tests', () {
    test('getEmailSubject returns correct subject', () {
      final subject = getEmailSubject();
      expect(subject, "🎉 You're Invited to Our Event!");
    });

    test('getEmailBody contains eventId in link', () {
      const eventId = "12345";
      final body = getEmailBody(eventId);

      // Check the link is correctly inserted
      expect(body.contains("https://eventsufyan.com?eventId=$eventId"), isTrue);
    });

    test('getEmailBody has expected greeting', () {
      final body = getEmailBody("999");

      // Greeting line
      expect(body.startsWith("Hello,"), isTrue);

      // Closing line
      expect(body.contains("Best Regards"), isTrue);
      expect(body.contains("Event Management Team"), isTrue);
    });
  });
}
