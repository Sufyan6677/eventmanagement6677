// import 'dart:math';

import 'dart:developer';
import 'dart:io';

import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:eventmanagement/widgets/user_infowidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

// import '../authentication/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      } else {
        print('no object seleected');
      }
    } catch (e) {
      print('error while picking image');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Section with Stack
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 130,
                color: const Color.fromARGB(225, 255, 193, 7), // light purple
              ),
              Positioned(
                bottom: -75, // moves half of the circle outside the container
                left: MediaQuery.of(context).size.width / 2 - 75,
                child: CircleAvatar(
                  radius: 83,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        image != null
                            ? FileImage(image!)
                            : const NetworkImage(
                              "https://randomuser.me/api/portraits/women/65.jpg",
                            ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 90),
          ElevatedButton(
            onPressed: () {
              log('reached this point');
              context.push('/homeprofile/profilepicture');
            },
            child: GoogleText('View Picture', color: Colors.black),
          ), // space below avatar
          ElevatedButton(
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
            child: GoogleText('Edit'),
          ),
          GoogleText(
            userEmail.isNotEmpty ? userName : "Loading...",
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Phone",
                //       style: TextStyle(color: Colors.grey, fontSize: 16),
                //     ),
                //     SizedBox(width: 10),
                //     Text(
                //       "+5999-771-7171",
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const GoogleText("Mail", color: Colors.grey, fontSize: 16),
                    const SizedBox(width: 10),
                    GoogleText(
                      userEmail.isNotEmpty ? userEmail : "Loading...",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // Dark Mode Option
                const Divider(thickness: 1),

                // Profile Details Option
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const GoogleText("Profile details"),
                  onTap: () {
                    try {
                      context.push('/profilepage/profiledetails');
                    } catch (e) {
                      print("Logout error: $e"); // For debugging
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: GoogleText("Profile details not loaded❌"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
                const Divider(thickness: 1),

                // Settings Option
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const GoogleText("Settings"),
                  onTap: () {
                    // Navigate to settings page
                  },
                ),
                const Divider(thickness: 1),

                // Logout Option
                ListTile(
  leading: const Icon(Icons.logout),
  title: const GoogleText("Log out"),
  onTap: () async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: GoogleText("Logout Successful 🎉"),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/login'); // better to use go instead of push for login
    } catch (e) {
      print("Logout error: $e"); // Debugging

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: GoogleText("Logout failed ❌"),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
