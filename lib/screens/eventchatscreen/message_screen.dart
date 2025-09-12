
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanagement/database/databaseservice2.dart';

import 'package:eventmanagement/screens/eventchatscreen/data_controller.dart';
import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final DataController dataController = Get.find<DataController>();
  String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 145, 235),
      appBar: AppBar(
    backgroundColor: Colors.white,
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
      "Chats",
      
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      
    ),
  ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Title
              
              SizedBox(height: screenheight * 0.03),

              // 🔹 Search bar (for users)
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  style: const TextStyle(color: Colors.grey),
                  onChanged: (String input) {
                    if (input.isEmpty) {
                      dataController.filteredUsers = List.from(
                        dataController.allUsers,
                      );
                    } else {
                      List<DocumentSnapshot> users =
                          dataController.allUsers.where((element) {
                            String name;
                            try {
                              name =
                                  element.get('first') +
                                  ' ' +
                                  element.get('last');
                            } catch (e) {
                              name = '';
                            }
                            return name.toLowerCase().contains(
                              input.toLowerCase(),
                            );
                          }).toList();

                      dataController.filteredUsers = users;
                      setState(() {});
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search Users",
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 🔹 Group Chats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GoogleText(
                  "Event Chats",
                  fontSize: 23, fontWeight: FontWeight.bold),
                
              ),

              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('events')
                        .where('attendees', arrayContains: myUid)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  var events = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      var event = events[index];
                      String eventName = event['eventname'] ?? 'Unnamed Event';
                      String eventId = event.id;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://picsum.photos/200?random=$index",
                          ),
                        ),

                        title: GoogleText(eventName),
                        onTap: () async {
                          final databaseService = Databaseservice();
                          String? fcmToken = await databaseService.getFcmToken(
                            myUid,
                          ); // fetch token

                          context.push(
                            '/messagescreen/chatroomscreen/$eventId/${Uri.encodeComponent(eventName)}',
                            extra: {
                              'image': '', // optional
                              'fcmToken': fcmToken, // fetched from DB
                              'uid': myUid,
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataController.filteredUsers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String name = '', image = '', fcmToken = '';

                    try {
                      name =
                          dataController.filteredUsers[index].get('first') +
                          ' ' +
                          dataController.filteredUsers[index].get('last');
                    } catch (e) {
                      name = '';
                    }

                    try {
                      image = dataController.filteredUsers[index].get('image');
                    } catch (e) {
                      image = '';
                    }

                    try {
                      fcmToken = dataController.filteredUsers[index].get(
                        'fcmToken',
                      );
                    } catch (e) {
                      fcmToken = '';
                    }

                    if (dataController.filteredUsers[index].id == myUid) {
                      return Container();
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://picsum.photos/200?random=$index",
                        ),
                      ),
                      title: GoogleText(name),
                      onTap: () {
                        String chatRoomId = '';
                        if (myUid.hashCode >
                            dataController.filteredUsers[index].id.hashCode) {
                          chatRoomId =
                              '$myUid-${dataController.filteredUsers[index].id}';
                        } else {
                          chatRoomId =
                              '${dataController.filteredUsers[index].id}-$myUid';
                        }

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context) => ChatRoomScreen(
                        //           groupId: chatRoomId,
                        //           name: name,
                        //           image: image,
                        //           fcmToken: fcmToken,
                        //           uid: dataController.filteredUsers[index].id,
                        //         ),
                        //   ),
                        // );
                        context.push(
                          '/messagescreen/directchat/$chatRoomId/${Uri.encodeComponent(name)}'
                          '?image=${Uri.encodeComponent(image)}&fcmToken=${Uri.encodeComponent(fcmToken)}&uid=$myUid',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
