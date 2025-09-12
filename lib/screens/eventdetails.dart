import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class EventDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? eventData;
  final String documentId;
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.documentId,
    required this.eventData,
    required this.eventId,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isAttending = false;
  // final String currentUsername = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> get event => widget.eventData ?? {};
  void toggleAttendance(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid ?? "unknown uid";
    final docRef = FirebaseFirestore.instance.collection('events').doc(docId);
    // Fetch current event data
    final docSnap = await docRef.get();
    final eventData = docSnap.data() as Map<String, dynamic>;
    // Convert to List<String>
    List<String> attendees = List<String>.from(eventData['attendees'] ?? []);
    if (isAttending) {
      // ✅ Remove user from event attendees
      attendees.remove(uid);
      setState(() {
        isAttending = false;
        event['attendees'] = attendees;
      });
      // ✅ Remove user from the group chat participants
      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(docId); // use eventId as chatId
      await chatRef.update({
        'participants': FieldValue.arrayRemove([uid]),
      });
    } else {
      // ✅ Add user to event attendees
      attendees.add(uid);
      setState(() {
        isAttending = true;
        event['attendees'] = attendees;
      });
      // ✅ Create group chat if it doesn’t exist, else just add participant
      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(docId); // eventId = chatId
      final chatSnap = await chatRef.get();
      if (!chatSnap.exists) {
        await chatRef.set({
          'eventId': docId,
          'eventName': eventData['eventname'] ?? 'Unnamed Event',
          'participants': [uid],
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await chatRef.update({
          'participants': FieldValue.arrayUnion([uid]),
        });
      }
    }

    // ✅ Update event attendees in Firestore
    await docRef.update({'attendees': attendees});
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? "";
    List<String> attendees = List<String>.from(event['attendees'] ?? []);
    isAttending = attendees.contains(uid); // ✅ check by UID
  }

  @override
  Widget build(BuildContext context) {
    // Attendees stored in Firestore as a List<String>
    final List<String> attendeeList = List<String>.from(
      event['attendees'] ?? [],
    );

    // Organizer (if it's a Map in Firestore)
    final Map<String, dynamic> organizer = Map<String, dynamic>.from(
      event['organizer'] ?? {},
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 118, 145, 235),
        appBar: AppBar(
          
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.pop(); // GoRouter back navigation
              // If not using GoRouter, use: Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: GoogleText(
            "Details",

            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Category
              Center(
                child: GoogleText(
                  event['eventname'] ?? 'No Title',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  "https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/200",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),

              const SizedBox(height: 4),

              const Divider(height: 20, thickness: 2),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoogleText(
                        event['category'] ?? "No Category",
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 8),
                          GoogleText(
                            (event['Date&Time'] as Timestamp)
                                .toDate()
                                .toString()
                                .substring(0, 16),
                            fontSize: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GoogleText(
                              event['eventlocation'] ?? 'No location',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GoogleText(
                        event['description'] ?? 'No description provided',
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ),
              //event organizer info
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoogleText(
                        "Organizer",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.blueAccent,
                        ),

                        title: GoogleText("ID: ${widget.eventId}"),
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                        title: GoogleText(
                          organizer['organizername'] ?? "Unknown",
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Colors.deepPurple,
                        ),
                        title: GoogleText(
                          organizer['emailcontact'] ?? "No Email",
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.green),
                        title: GoogleText(
                          organizer['phonecontact'] ?? "No Phone",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoogleText(
                        "Attendees (${attendeeList.length})",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            attendeeList
                                .map(
                                  (name) => Chip(
                                    label: GoogleText(name),
                                    avatar: const Icon(Icons.person, size: 18),
                                    backgroundColor: Colors.amber.shade100,
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoogleText(
                        "Meet Link",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 12),

                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                        title: GoogleText(event['meetLink'] ?? "Unknown"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    toggleAttendance(widget.documentId);
                  },
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.white,
                    backgroundColor: Colors.amber,
                  ),
                  icon: Icon(isAttending ? Icons.remove : Icons.add),
                  label: GoogleText(
                    isAttending ? 'Leave Event' : 'Join Event',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      '/eventlist/eventdetails/eventinvite',
                      extra: widget.documentId,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: GoogleText(
                    'Invite Members',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Join/Leave Button

              // Center(
              //   child: ElevatedButton.icon(
              //     onPressed: () {},
              //     icon: Icon(isAttending ? Icons.remove : Icons.add),
              //     label: Text(isAttending ? 'Leave Event' : 'Join Event'),
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 40,
              //         vertical: 14,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
