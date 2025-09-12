// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> MeetService(String documentId) async {
  try {
    // Generate a unique meet link (this is just a placeholder, you can use API later)
    String meetLink = "https://meet.google.com/${DateTime.now().millisecondsSinceEpoch}";

    // Store the link in Firestore under the given document
    await FirebaseFirestore.instance
        .collection("events")
        .doc(documentId)
        .update({
      "meetLink": meetLink,
    });

    print("Meet link created and stored successfully!");
  } catch (e) {
    print("Error creating/storing meet link: $e");
  }
}
