import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Profilepicture extends StatelessWidget {
  final File? imageFile;       // optional local image to show immediately
  final String userId;         // user whose picture you want
  final double radius;         // optional size
  final bool showScaffold;     // true if you want this widget as a full page

  const Profilepicture({
    super.key,
    this.imageFile,
    required this.userId,
    this.radius = 80,
    this.showScaffold = false,
  });

  /// Uploads image to Firebase Storage
  Future<String> uploadProfilePicture(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$userId.jpg');
      await ref.putFile(image);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload error: $e');
      return '';
    }
  }

  /// Saves download URL to Firestore
  Future<void> saveProfilePictureUrl(String url) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePictureUrl': url,
      });
    } catch (e) {
      print('Firestore update error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final widgetContent = CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: imageFile != null
          ? FileImage(imageFile!)
          : NetworkImage(
              "https://firebasestorage.googleapis.com/v0/b/YOUR_BUCKET_NAME/o/profile_pictures%2F$userId.jpg?alt=media",
            ) as ImageProvider,
    );

    // If showScaffold = true, show full page, else just the avatar
    if (showScaffold) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile Picture')),
        body: Center(child: widgetContent),
      );
    } else {
      return widgetContent;
    }
  }
}
