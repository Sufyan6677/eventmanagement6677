// ignore_for_file: use_build_context_synchronously

import 'package:eventmanagement/authentication/forgot_password.dart';
import 'package:eventmanagement/widgets/custombutton.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:flutter/material.dart';

// import 'package:auth_demo/homeprofiledetails.dart';
import 'package:go_router/go_router.dart';
// import 'signup.dart';
import 'auth_service2.dart';

class Logina extends StatefulWidget {
  static const String id = 'Logina';
  const Logina({super.key});

  @override
  State<Logina> createState() => _LoginaState();
}

class _LoginaState extends State<Logina> {
  final _auth = AuthService();
  bool isLoading = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                // Title
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "Enter your login information",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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

                            try {
                              final user = await _auth.loginWithGoogle();

                              if (user != null) {
                                // Success snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: GoogleText(
                                      "Logged in successfully! 🎉",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Small delay so the snackbar shows before navigation
                                await Future.delayed(
                                  const Duration(milliseconds: 500),
                                );

                                context.go(
                                  '/eventlist',
                                ); // Navigate to event list
                              } else {
                                // Failed login
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: GoogleText(
                                      "Google login failed ❌",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              // Exception error
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: GoogleText(
                                    "Error occurred: ${e.toString()} ❌",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
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
                      child: GoogleText("OR"),
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

                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: const Icon(Icons.email_outlined),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(color: Colors.black),
                        ),

                        // Border when FOCUSED
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color:
                                Colors
                                    .amber, // 👈 change this to your desired color
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GoogleText(
                      'Password',

                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    // Password field
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,

                      controller: _password,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color:
                                Colors
                                    .amber, // 👈 change this to your desired color
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ForgotPassword.showDialogBox(context);
                    },
                    child: const GoogleText(
                      "Forgot Password?",
                      color: Colors.amber,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Login Button
                SizedBox(
                  height: 50,
                  child: CustomTextButton(
                    textSize: 18,
                    textColor: Colors.white,
                    backgroundColor: Colors.amber,
                    text: 'Sign-in',
                    fontWeight: FontWeight.bold,
                    borderRadiusCircular: 12,
                    borderColor: Colors.white,
                    onPressed: () async {
                      final user = await _auth.singinUserWithEmailAndPassword(
                        _email.text,
                        _password.text,
                      );
                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: GoogleText("Login Successful 🎉"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        await Future.delayed(const Duration(milliseconds: 500));
                        context.go('/eventlist');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: GoogleText("Invalid Credentials ❌"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const GoogleText(
                      "Don't have an account? ",
                      fontWeight: FontWeight.bold,
                    ),

                    TextButton(
                      onPressed: () {
                        context.go('/signup');
                      },
                      child: const GoogleText(
                        "Sign Up",

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
