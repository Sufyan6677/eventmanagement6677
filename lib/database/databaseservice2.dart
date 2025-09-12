import 'dart:developer';
import 'package:eventmanagement/screens/profile/profiledetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../authentication/auth_service2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Databaseservice {
  final _firedb = FirebaseFirestore.instance;

  Future<String> createEvent(EventModel event) async {
    try {
      List<String> attendeesList = (event.attendees ?? "")
    .split(',')
    .where((attendee) => attendee.trim().isNotEmpty)
    .map((attendee) => attendee.trim())
    .toList();
      // List<String> attendeesList = event.attendees.split(',').map((course) => course.trim()).toList();
      DocumentReference ref = await _firedb.collection("events").add({
        "eventname": event.title,
        "description": event.description,
        "category": event.category,
        "Date&Time": event.dateTime,
        // "end-date": user.enddate,
        "Created By": event.createdBy,
        // "end-time": user.endtime,
        "eventlocation": event.eventlocation,
        // "organizer":{"organizername": user.organizername,
        // "emailcontact": user.emailcontact,
        // "phonecontact": user.phonecontact},
        "attendees": attendeesList ,
      });
      return ref.id;
    } catch (e) {
      log('Something is wrong ');
    }
    return "";
  }
   createUser(User user) {
    try {
      _firedb.collection("users").add(user.toMap(
        
      ));
    } catch (e) {
      log('Something is wrong ');
    }
  }
    // ====================== FCM TOKEN =======================
  Future<void> saveFcmToken(String uid) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _firedb.collection("users").doc(uid).set({
          'fcmToken': fcmToken,
        }, SetOptions(merge: true));
        log('FCM Token saved for user $uid: $fcmToken');
      }
    } catch (e) {
      log('Error saving FCM token: $e');
    }
  }

  Future<String?> getFcmToken(String uid) async {
    try {
      DocumentSnapshot doc = await _firedb.collection("users").doc(uid).get();
      return doc.get('fcmToken');
    } catch (e) {
      log('Error fetching FCM token for $uid: $e');
    }
    return null;
  }
}

