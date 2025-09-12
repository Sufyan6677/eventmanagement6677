// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

class DataController {
  // Singleton pattern
  static final DataController _instance = DataController._internal();
  factory DataController() => _instance;
  DataController._internal();

  FirebaseAuth auth = FirebaseAuth.instance;

  DocumentSnapshot? myDocument;

  // Lists
  List<DocumentSnapshot> allUsers = [];
  List<DocumentSnapshot> filteredUsers = [];
  List<DocumentSnapshot> allEvents = [];
  List<DocumentSnapshot> filteredEvents = [];
  List<DocumentSnapshot> joinedEvents = [];

  // Booleans
  bool isEventsLoading = false;
  bool isUsersLoading = false;
  bool isMessageSending = false;

  // ----------------------- Methods -----------------------

  // Send Message
  Future<void> sendMessageToFirebase({
    Map<String, dynamic>? data,
    String? lastMessage,
    String? grouid,
  }) async {
    isMessageSending = true;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(grouid)
        .collection('chatroom')
        .add(data!);

    await FirebaseFirestore.instance.collection('chats').doc(grouid).set({
      'lastMessage': lastMessage,
      'groupId': grouid,
      'group': grouid!.split('-'),
    }, SetOptions(merge: true));

    isMessageSending = false;
  }

  // Create Notification
  void createNotification(String recUid) {
    if (myDocument == null) return;

    FirebaseFirestore.instance
        .collection('notifications')
        .doc(recUid)
        .collection('myNotifications')
        .add({
          'message': "Send you a message.",
          'image': myDocument!.get('image'),
          'name': myDocument!.get('first') + " " + myDocument!.get('last'),
          'time': DateTime.now(),
        });
  }

  // Get My User Document
  void getMyDocument() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .listen((event) {
          myDocument = event;
        });
  }

  // Upload Image File
  Future<String> uploadImageToFirebase(File file) async {
    String fileUrl = '';
    String fileName = Path.basename(file.path);
    var reference = FirebaseStorage.instance.ref().child('myfiles/$fileName');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    fileUrl = await taskSnapshot.ref.getDownloadURL();
    print("Url $fileUrl");
    return fileUrl;
  }

  // Upload Thumbnail
  Future<String> uploadThumbnailToFirebase(Uint8List file) async {
    String fileUrl = '';
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var reference = FirebaseStorage.instance.ref().child('myfiles/$fileName.jpg');
    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    fileUrl = await taskSnapshot.ref.getDownloadURL();
    print("Thumbnail $fileUrl");
    return fileUrl;
  }

  // Create Event
  Future<bool> createEvent(Map<String, dynamic> eventData, BuildContext context) async {
    bool isCompleted = false;

    await FirebaseFirestore.instance
        .collection('events')
        .add(eventData)
        .then((value) {
          isCompleted = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: GoogleText('Event is uploaded successfully.'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 2),
            ),
          );
        })
        .catchError((e) {
          isCompleted = false;
        });

    return isCompleted;
  }

  // ----------------------- Initialization -----------------------

  void init() {
    getMyDocument();
    getUsers();
    getEvents();

    print("DataController initialized");

    FirebaseFirestore.instance.collection("chats").snapshots().listen((snapshot) {
      print("Chats snapshot received with ${snapshot.docs.length} documents");
    });
  }

  // ----------------------- Users -----------------------
  void getUsers() {
    isUsersLoading = true;
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      allUsers = event.docs;
      filteredUsers = List.from(allUsers);
      isUsersLoading = false;
    });
  }

  // ----------------------- Events -----------------------
  void getEvents() {
    isEventsLoading = true;
    FirebaseFirestore.instance.collection('events').snapshots().listen((event) {
      allEvents = event.docs;
      filteredEvents = List.from(allEvents);

      joinedEvents = allEvents.where((e) {
        List joinedIds = [];
        if (e.data().toString().contains('joined')) {
          joinedIds = e.get('joined');
        }
        return joinedIds.contains(FirebaseAuth.instance.currentUser!.uid);
      }).toList();

      isEventsLoading = false;
    });
  }
}
