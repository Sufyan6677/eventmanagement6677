import 'dart:developer';
import 'dart:io';
import 'package:eventmanagement/screens/profile/profiledetails.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../authentication/auth_service2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Databaseservice {
  final _firedb = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

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
        // "category": user.category,
        "Date&Time": event.dateTime,
        // "end-date": user.enddate,
        "Created By": event.createdBy,
        // "end-time": user.endtime,
        "eventlocation": event.eventlocation,
        // "organizer":{"organizername": user.organizername,
        // "emailcontact": user.emailcontact,
        // "phonecontact": user.phonecontact},
        "attendees": attendeesList,
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
  Future<String?> uploadUserProfilePicture(String userId, File imageFile) async {
    try {
      // Storage reference: profile_pictures/userId.jpg
      final ref = _storage.ref().child("profile_pictures/$userId.jpg");

      // Upload file
      await ref.putFile(imageFile);

      // Get download URL
      String downloadUrl = await ref.getDownloadURL();

      // Save in Firestore (users collection, document = userId)
      await _firedb.collection("users").doc(userId).set({
        "profilePictureUrl": downloadUrl,
      }, SetOptions(merge: true));

      return downloadUrl;
    } catch (e) {
      log("Error uploading profile picture: $e");
      return null;
    }
  }

}
