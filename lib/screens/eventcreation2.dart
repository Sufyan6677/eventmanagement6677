// ignore_for_file: use_build_context_synchronously

import 'package:eventmanagement/authentication/meet_service.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/auth_service2.dart';
import '../database/databaseservice2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final _dbservice = Databaseservice();
  final _authservice = AuthService();
  final List<String> categories = [
    "Music",
    "Sports",
    "Education",
    "Business",
    "Technology",
  ];

  String? selectedCategory;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _title = TextEditingController();
  // final _category = TextEditingController();
  final _description = TextEditingController();
  // final _startdate = TextEditingController();
  // final _enddate = TextEditingController();
  // final _starttime = TextEditingController();
  // final _endtime = TextEditingController();
  final _eventlocation = TextEditingController();
  // final _organizername = TextEditingController();
  // final _contactemail = TextEditingController();
  // final _contactphone = TextEditingController();
  // final attendees = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    // _category.dispose();
    _description.dispose();
    // _startdate.dispose();
    // _enddate.dispose();
    // _starttime.dispose();
    // _endtime.dispose();
    _eventlocation.dispose();

    // _organizername.dispose();
    // _contactemail.dispose();
    // _contactphone.dispose();
    // attendees.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 00),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 118, 145, 235),
        // appBar: AppBar(title: const Text("Create Event"), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GoogleText(
                  "Create Event",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // ——— Fields ———
              _labeledField(
                controller: _title,
                title: "Event Name",
                hint: "Enter event name",
                
              ),
              _labeledField(
                controller: _description,
                title: "Description",
                hint: "Write a short description",
                maxLines: 3,
              ),
              TextButton(onPressed: _pickDate, child: GoogleText('Pick Date',color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
              TextButton(onPressed: _pickTime, child: GoogleText('Pick Time',color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
              GoogleText('Category', fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                hint: const GoogleText("Select Category",color: Colors.white60,),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.amber,
                      width: 2.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items:
                    categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              // _labeledField(
              //   controller: _starttime,
              //   title: "Start Time",
              //   hint: "HH:MM",
              // ),
              // _labeledField(
              //   controller: _endtime,
              //   title: "End Time",
              //   hint: "HH:MM",
              // ),
              _labeledField(
                controller: _eventlocation,
                title: "Event Location",
                hint: "Enter venue or online link",
              ),

              // _labeledField(
              //   controller: attendees,
              //   title: "Attendees",
              //   hint: "Comma-separated emails/usernames",
              //   maxLines: 2,
              // ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_title.text.isEmpty ||
                        _description.text.isEmpty ||
                        _selectedDate == null ||
                        _selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: GoogleText("Please fill all fields!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // 👈 stop further execution
                    }

                    final DateTime eventDateTime = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    );

                    final event = EventModel(
                      title: _title.text,
                      description: _description.text,
                      dateTime: eventDateTime,
                      category: selectedCategory ?? "Uncategorized",

                      createdBy: FirebaseAuth.instance.currentUser!.uid,
                      eventlocation: _eventlocation.text,
                      attendees: '',
                    );

                    try {
                      final docId = await _dbservice.createEvent(event);

                      await _authservice.addEventToGoogleCalendar(
                        title: event.title,
                        description: event.description,
                        dateTime: event.dateTime,
                        createdBy: event.createdBy,
                      );

                      // ✅ Success Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: GoogleText("Event created successfully 🎉"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      await MeetService(docId);

                      // ✅ Success Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: GoogleText(
                            "Event created with Meet link 🎉",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // small delay so user sees snackbar before navigating
                      await Future.delayed(const Duration(seconds: 1));

                      context.push('/eventlist');
                    } catch (e) {
                      // ❌ Error Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: GoogleText("Failed to create event: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  child: const GoogleText(
                    "Save Event",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A helper that renders a title text above a TextField,
  /// with consistent spacing everywhere.
  Widget _labeledField({
    required String title,
    String? hint,
    int maxLines = 1,
    TextEditingController? controller,
    

    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoogleText(title, color: Colors.white,fontSize: 20, fontWeight: FontWeight.w800),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint ?? '',
            hintStyle: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 227, 222, 222),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: Colors.white),
            ),

            // Border when FOCUSED
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.amber, // 👈 change this to your desired color
                width: 2.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16), // spacing between fields
      ],
    );
  }
}
