import 'package:eventmanagement/screens/eventcard.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:eventmanagement/widgets/user_infowidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String userName='';
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
                  SizedBox(width: 10,),
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
                          GoogleText('Greetings  ',fontSize: 18,),
                          GoogleText(
                            userName,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      GoogleText('Explore the amazing events ',fontSize: 18,),
                    ],
                  ),
                ],
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
                      'Upcoming Events',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},

                    child: GoogleText('View All', fontSize: 13),
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
                    ),
                  ),
                  TextButton(
                    onPressed: () {},

                    child: GoogleText('View All', fontSize: 13),
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
