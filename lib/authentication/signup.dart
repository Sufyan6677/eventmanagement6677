// import 'dart:developer';
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:eventmanagement/authentication/auth_service2.dart';
import 'package:eventmanagement/widgets/custombutton.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
// import 'auth_service.dart';
// import 'signuplogic.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class Signupa extends StatefulWidget {
  const Signupa({super.key});
  static const String id = 'Signupa';
  @override
  State<Signupa> createState() => _SignupaState();
}

class _SignupaState extends State<Signupa> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  bool isLoading = false;
  final _auth = AuthService();
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 145, 235),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Title
                const GoogleText(
                  "Sign Up Account",

                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),

                const SizedBox(height: 10),
                const GoogleText(
                  "Enter your data to create your account",
                  fontSize: 18,
                  color: Colors.grey,
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                        : CustomTextButton(
                          textSize: 15,
                          textColor: Colors.white,
                          backgroundColor: Colors.amber,
                          borderColor: Colors.white,

                          text: 'Google',
                          fontWeight: FontWeight.bold,
                          buttonHeight: 40,
                          buttonWidth: 150,
                          borderRadiusCircular: 12.0,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await _auth.loginWithGoogle();
                            setState(() {
                              isLoading = false;
                            });
                            context.push('/eventlist');
                          },
                        ),
                    SizedBox(width: 30),
                    // Apple Button
                    CustomTextButton(
                      textSize: 15,
                      textColor: Colors.white,
                      backgroundColor: Colors.amber,
                      borderColor: Colors.white,
                      text: 'Apple',
                      fontWeight: FontWeight.bold,
                      buttonHeight: 40,
                      buttonWidth: 150,
                      borderRadiusCircular: 12,
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: GoogleText("OR",color: Colors.white,),
                    ),
                    Expanded(child: Divider(thickness: 2)),
                  ],
                ),
                SizedBox(height: 10),
                // Email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoogleText(
                      'Email Address',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration: InputDecoration(
                        
                        prefixIcon: const Icon(Icons.email_outlined,color: Colors.white,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    GoogleText(
                      'Password',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    // Password field
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      controller: _password,
                      decoration: InputDecoration(
                        
                        prefixIcon: const Icon(Icons.lock_outline,color: Colors.white,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GoogleText(
                      'Confirm Password',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    // Password field
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      controller: _confirmpassword,
                      decoration: InputDecoration(
                        
                        prefixIcon: const Icon(Icons.lock_outline,color: Colors.white,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Forgot password
                GoogleText('Must contain atleast 6 characters', fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600,),

                const SizedBox(height: 10),

                // Login Button
                SizedBox(
                  height: 50,
                  child: CustomTextButton(
                    textSize: 18,
                    textColor: Colors.white,
                    backgroundColor: Colors.amber,
                    text: 'Sign-Up',
                    fontWeight: FontWeight.bold,
                    borderRadiusCircular: 12,
                    borderColor: Colors.white,
                    onPressed: () async {
                      if (_password.text != _confirmpassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
        content: GoogleText("Password don't match ❌"),
        backgroundColor: Colors.green,
      ),
                        );
                        return; // 🚫 Stop the signup process if passwords mismatch
                      }

                      try {
                        final newUser = await _auth
                            .createUserWithEmailAndPassword(
                              _email.text,
                              _password.text,
                            );
                        if (newUser != null) {
                          context.push('/login');
                          // Optionally navigate to next screen
                        }
                      } catch (e) {
                        print("Signup Error: $e");
                      }
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const GoogleText(
                      "Already have an account? ",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),

                    TextButton(
                      onPressed: () {
                        context.push('/login');
                      },
                      child: const GoogleText(
                        "Sign In",

                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

