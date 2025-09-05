// ignore_for_file: use_build_context_synchronously

import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword {
  static void showDialogBox(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const GoogleText("Reset Password"),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "Enter your email",
            
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const GoogleText("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _sendPasswordReset(emailController.text.trim(), context);
            },
            child: const GoogleText("Send"),
          ),
        ],
      ),
    );
  }

  static Future<void> _sendPasswordReset(String email, BuildContext context) async {
    try {
      print("Sending password reset to: $email");
await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
print("Password reset email sent!");
      Navigator.pop(context); // close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: GoogleText("Password reset link sent! Check your email.",color: Colors.white)),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong!";
      if (e.code == 'user-not-found') {
        message = "No user found with this email.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: GoogleText(message)),
      );
    }
  }
}
