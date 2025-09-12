// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/calendar/v3.dart' as calendar show CalendarApi;
import 'package:http/http.dart' as http;

class AuthService {
  final _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar',
      'https://www.googleapis.com/auth/calendar.events',
      'https://www.googleapis.com/auth/contacts.readonly', // ✅ changed from readonly so we can add events
    ],
  );

  // ---------------- Google Login ----------------
  Future<UserCredential?> loginWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  // ---------------- Signup ----------------
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      log('some error occurred: $e');
    }
    return null;
  }

  // ---------------- Signin ----------------
  Future<User?> singinUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      log('some error occurred: $e');
    }
    return null;
  }

  // ---------------- Fetch Google Calendar Events ----------------
  Future<List<dynamic>> getCalendarEvents() async {
    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser == null) {
      throw Exception("User not signed in");
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;

    final response = await http.get(
      Uri.parse(
        "https://www.googleapis.com/calendar/v3/calendars/primary/events",
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["items"] ?? [];
    } else {
      throw Exception("Failed to fetch calendar events: ${response.body}");
    }
  }

  // ---------------- Add Event to Google Calendar ----------------
  Future<void> addEventToGoogleCalendar({
    required String title,
    required String description,
    required DateTime dateTime,
    required String createdBy,

    DateTime? endTime,
  }) async {
    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser == null) {
      throw Exception("User not signed in");
    }
    endTime ??= dateTime.add(const Duration(hours: 1));
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;

    final event = {
      "summary": title,
      "description": description,
      "start": {
        "dateTime": dateTime.toUtc().toIso8601String(),
        "timeZone": "Asia/Karachi",
      },
      "end": {
        "dateTime": endTime.toUtc().toIso8601String(),
        "timeZone": "Asia/Karachi",
      },
    };

    final response = await http.post(
      Uri.parse(
        "https://www.googleapis.com/calendar/v3/calendars/primary/events",
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: json.encode(event),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception("Failed to add event: ${response.body}");
    }
  }
}

class EventModel {
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;
  final String createdBy;
  final String? attendees;
  final String eventlocation;

  EventModel({
    this.attendees,
    required this.title,
    required this.description,
    required this.category,
    required this.eventlocation,
    required this.dateTime,
    required this.createdBy,
  });
}
