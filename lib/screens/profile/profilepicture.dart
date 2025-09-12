import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class Profilepicture extends StatelessWidget {
  final File? imageFile;
  final String userId;
  const Profilepicture({super.key, this.imageFile, required this.userId});
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
    return Scaffold(
      appBar: AppBar(title: GoogleText('Sufyan')),
      body: Center(
        child:
            imageFile != null
                ? Image.file(imageFile!)
                : const GoogleText('No image selected'),
      ),
    );
  }
}
