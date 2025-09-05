// import 'package:auth_demo/custombutton.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:flutter/material.dart';
import 'package:eventmanagement/database/databaseservice2.dart';

class HomeProfileDetails extends StatefulWidget {
  const HomeProfileDetails({super.key});

  @override
  State<HomeProfileDetails> createState() => _HomeProfileDetails();
}

class _HomeProfileDetails extends State<HomeProfileDetails> {
  final _dbservice = Databaseservice();
  final _name = TextEditingController();
  final _fname = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _name.dispose();
    _phone.dispose();
    _fname.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
        
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: GoogleText(
                  "Profile Details",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _name,
                // obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _fname,
                // obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Father Name',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _phone,
                // obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _email,
                // obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final user = User(
                    name: _name.text,
                    fname: _fname.text,
                    email: _email.text,
                    phone: _phone.text,
                  );
                  _dbservice.createUser(user);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: const GoogleText(
                  'Submit',
        
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
        
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: const GoogleText(
                  'Weather',
        
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
        
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final String name, fname, phone, email;
  String? profilepictureUrl;
  User({
    required this.name,
    required this.fname,
    required this.phone,
    required this.email,
    this.profilepictureUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'name':name,
      'fname':fname,
      'phone':phone,
      'email':email,
      'profilePictureUrl':profilepictureUrl,
    };
  }
}
