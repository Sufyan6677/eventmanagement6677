import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String userName = '';
String userEmail = '';

Future<void> fetchUserData() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      userName = data['name'] ?? '';
      userEmail = data['email'] ?? '';
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }
}
