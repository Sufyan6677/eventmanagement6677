import 'package:eventmanagement/screens/eventcard.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:eventmanagement/widgets/user_infowidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String userName = '';
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Workshop',
    'Sports',
    'Study',
    'Music',
  ];

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        setState(() {
          userName = doc['name'] ?? '';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 145, 235),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/${DateTime.now().millisecondsSinceEpoch % 100}.jpg',
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Row(
                        children: [
                          GoogleText(
                            'Greetings  ',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          GoogleText(
                            userName,
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      GoogleText(
                        'Explore the amazing events ',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search events...",
                        prefixIcon: Icon(Icons.search, color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 181, 195, 240),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                        ), // 👈 keeps height small
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items:
                          categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat,
                                overflow: TextOverflow.ellipsis,
                              ), // 👈 avoids long text overflow
                            );
                          }).toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 181, 195, 240),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ), // 👈 reduce padding
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GoogleText(
                      'Upcoming Events',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},

                    child: GoogleText(
                      'View All',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('events').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var events = snapshot.data!.docs;
                  // Apply search filter
                  if (selectedCategory != 'All') {
                    events =
                        events.where((event) {
                          final category = (event['category'] ?? '').toString();
                          return category == selectedCategory;
                        }).toList();
                  }

                  if (searchQuery.isNotEmpty) {
                    events =
                        events.where((event) {
                          final name =
                              (event['eventname'] ?? '')
                                  .toString()
                                  .toLowerCase();
                          final location =
                              (event['eventlocation'] ?? '')
                                  .toString()
                                  .toLowerCase();
                          return name.contains(searchQuery) ||
                              location.contains(searchQuery);
                        }).toList();
                  }

                  return SizedBox(
                    height: 290, // height of each card
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        var event = events[index];

                        return EventCard(
                          title: event['eventname'] ?? 'No Title',
                          date: (event['Date&Time'] as Timestamp)
                              .toDate()
                              .toString()
                              .substring(0, 16), // format trimmed
                          eventlocation: event['eventlocation'] ?? 'Unknown',
                          attendeescount:
                              (event['attendees'] as List?)?.length ?? 0,
                          // description: event['description'],
                          onTap: () {
                            // Convert Firestore data safely
                            final Map<String, dynamic> data =
                                Map<String, dynamic>.from(event.data());

                            if (data['attendees'] is Set) {
                              data['attendees'] =
                                  (data['attendees'] as Set).toList();
                            }

                            context.push(
                              '/eventlist/eventdetails',
                              extra: {
                                'eventId': event.id,
                                'data': data,
                                'documentId': event.id,
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GoogleText(
                      'Recommended Events',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},

                    child: GoogleText(
                      'View All',
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('events').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var events = snapshot.data!.docs;

                  // Apply search filter
                  // Apply category filter
                  if (selectedCategory != 'All') {
                    events =
                        events.where((event) {
                          final category = (event['category'] ?? '').toString();
                          return category == selectedCategory;
                        }).toList();
                  }

                  // Apply search filter
                  if (searchQuery.isNotEmpty) {
                    events =
                        events.where((event) {
                          final name =
                              (event['eventname'] ?? '')
                                  .toString()
                                  .toLowerCase();
                          final location =
                              (event['eventlocation'] ?? '')
                                  .toString()
                                  .toLowerCase();
                          return name.contains(searchQuery) ||
                              location.contains(searchQuery);
                        }).toList();
                  }
                  return SizedBox(
                    height: 280, // height of each card
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        var event = events[index];

                        return EventCard(
                          title: event['eventname'] ?? 'No Title',
                          date: (event['Date&Time'] as Timestamp)
                              .toDate()
                              .toString()
                              .substring(0, 16), // format trimmed
                          eventlocation: event['eventlocation'] ?? 'Unknown',
                          attendeescount:
                              (event['attendees'] as List?)?.length ?? 0,
                          // description: event['description'],
                          onTap: () {
                            // Convert Firestore data safely
                            final Map<String, dynamic> data =
                                Map<String, dynamic>.from(event.data());

                            if (data['attendees'] is Set) {
                              data['attendees'] =
                                  (data['attendees'] as Set).toList();
                            }

                            context.push(
                              '/eventlist/eventdetails',
                              extra: {
                                'eventId': event.id,
                                'data': data,
                                'documentId': event.id,
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // ElevatedButton(
            //   onPressed: () {

            //     context.push('/eventcreation');
            //   },
            //   child: GoogleText('Create Event', fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
