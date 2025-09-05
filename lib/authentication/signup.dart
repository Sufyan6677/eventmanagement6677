// import 'dart:developer';
// ignore_for_file: avoid_print

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
      backgroundColor: Colors.white,
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
                  color: Colors.black87,
                ),

                const SizedBox(height: 10),
                const GoogleText(
                  "Enter your data to create your account",
                  fontSize: 16,
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
                          backgroundColor: Colors.orange,
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
                      backgroundColor: Colors.orange,
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
                      ),
                    ),

                    const SizedBox(height: 10),
                    GoogleText(
                      'Password',

                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    GoogleText(
                      'Confirm Password',

                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    // Password field
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      controller: _confirmpassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Forgot password
                GoogleText('Must contain atleast 6 characters', fontSize: 16),

                const SizedBox(height: 10),

                // Login Button
                SizedBox(
                  height: 50,
                  child: CustomTextButton(
                    textSize: 18,
                    textColor: Colors.white,
                    backgroundColor: Colors.orange,
                    text: 'Sign-Up',
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
                    ),

                    TextButton(
                      onPressed: () {
                        context.push('/login');
                      },
                      child: const GoogleText(
                        "Sign In",

                        color: Colors.orange,
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
//       backgroundColor: Color(0xFF676BD0),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 40),
//             const Text(
//               'SIGNUP',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.amber,
//                 fontSize: 35,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 40),

//             // Email TextField
//             TextField(
//               controller: _email,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 labelStyle: TextStyle(color: Colors.amber),

//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Password TextField
//             TextField(
//               controller: _password,
//               obscureText: true,
//               keyboardType: TextInputType.text,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 labelStyle: TextStyle(color: Colors.amber),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 30),
//             TextField(
//               obscureText: true,
//               keyboardType: TextInputType.text,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 labelStyle: TextStyle(color: Colors.amber),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 30),
//             // Login Button
//             ElevatedButton(
//               onPressed: () async {
//                 final user = await _auth.createUserWithEmailAndPassword(
//                   _email.text,
//                   _password.text,
//                 );
//                 if (user != null) {
//                   log('User created successfuly');
//                   Navigator.pushNamed(context, Logina.id);
//                 }
//               },
//               child: const Text(
//                 'Signup',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.amber,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
