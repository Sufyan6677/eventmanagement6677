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
        backgroundColor: Colors.white,
        // appBar: AppBar(title: const Text("Create Event"), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoogleText(
                "Create Event",
                fontSize: 30,
                fontWeight: FontWeight.bold,
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
              TextButton(onPressed: _pickDate, child: GoogleText('Pick Date')),
              TextButton(onPressed: _pickTime, child: GoogleText('Pick Time')),
              // _labeledField(
              //   controller: _category,
              //   title: "Category",
              //   hint: "e.g. Workshop, Sports, Study",
              // ),
              // _labeledField(
              //   controller: _startdate,
              //   title: "Start Date",
              //   hint: "YYYY-MM-DD",
              // ),
              // _labeledField(
              //   controller: _enddate,
              //   title: "End Date",
              //   hint: "YYYY-MM-DD",
              // ),
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
                      createdBy: FirebaseAuth.instance.currentUser!.uid,
                      eventlocation: _eventlocation.text,
                    );

                    try {
                      final docId=await _dbservice.createEvent(event);

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
        content: GoogleText("Event created with Meet link 🎉"),
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
        GoogleText(title, fontSize: 14, fontWeight: FontWeight.w800),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint ?? '',
            hintStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 95, 94, 94),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: Colors.black),
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
