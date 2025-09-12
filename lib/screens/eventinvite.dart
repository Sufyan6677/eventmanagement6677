// ignore_for_file: use_build_context_synchronously, unused_catch_clause, unused_local_variable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanagement/widgets/email_template.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EventInvite extends StatefulWidget {
  final String eventId;
  const EventInvite({super.key, required this.eventId});

  @override
  State<EventInvite> createState() => _EventInviteState();
}

class _EventInviteState extends State<EventInvite> {
  final TextEditingController _emailsController = TextEditingController();

  bool _isSending = false;

  Future<void> sendToMultiple(
    List<String> recipients,
    String subject,
    String body,
  ) async {
    // ⚠️ Replace these with your Gmail + App Password
    const String username = 'maliksufyan34567@gmail.com';
    const String appPassword = 'zrym mntc nnua rrpj';

    final smtpServer = gmail(username, appPassword);

    final message =
        Message()
          ..from = Address(username, 'Event App')
          ..recipients.addAll(recipients)
          ..subject = subject
          ..text = body;

    try {
      final sendReport = await send(message, smtpServer);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: GoogleText("Invitations sent successfully!")),
      );
    } on MailerException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: GoogleText("Failed to send invitations")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    log("Event ID: ${widget.eventId}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.pop(); // GoRouter back navigation
              // If not using GoRouter, use: Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: GoogleText(
            "Chats",

            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emails Input
              Center(
                child: GoogleText(
                  'Send Invites',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),
              TextField(
                controller: _emailsController,
                decoration: const InputDecoration(
                  labelText: "Emails",
                  hintText: "Enter emails separated by commas",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Send Button
              Center(
                child:
                    _isSending
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () async {
                            List<String> emails =
                                _emailsController.text
                                    .split(',')
                                    .map((email) => email.trim())
                                    .where((email) => email.isNotEmpty)
                                    .toList();

                            if (emails.isNotEmpty) {
                              setState(() => _isSending = true);
                              await sendToMultiple(
                                emails,
                                emailSubject(),
                                getEmailBody(widget.eventId),
                              );
                              setState(() => _isSending = false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: GoogleText(
                                    "⚠️ Please fill all fields properly",
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          child: const GoogleText(
                            "Send Invitation",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.push('/acceptreject', extra: 'ZiRQaQUFI6mhxIGFgvHK');
                },
                child: GoogleText('Test  Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> addAttendee(String eventId, String userEmail) async {
  final eventRef = FirebaseFirestore.instance.collection('events').doc(eventId);

  await eventRef.update({
    'attendees': FieldValue.arrayUnion([userEmail]),
  });
}
