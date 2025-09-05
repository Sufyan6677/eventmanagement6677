// email_template.dart

String getEmailSubject() {
  return "🎉 You're Invited to Our Event!";
}

String getEmailBody(String eventId) {
  return """
Hello,

You are invited to join our event 🎊.
Please click the link below to view details and RSVP:

👉 https://eventsufyan.com?eventId=$eventId

Best Regards,  
Event Management Team
""";
}

String emailSubject() {
  return 'Event Invite';
}
