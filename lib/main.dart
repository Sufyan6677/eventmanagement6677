// ignore_for_file: unused_element

import 'package:eventmanagement/authentication/firebase_options.dart';
import 'package:eventmanagement/screens/eventchatscreen/chat_room_screen.dart';
import 'package:eventmanagement/screens/eventchatscreen/message_screen.dart';

import 'package:eventmanagement/screens/eventcreation2.dart';
import 'package:eventmanagement/screens/eventdetails.dart';
import 'package:eventmanagement/screens/eventinvite.dart';
import 'package:eventmanagement/screens/home/eventlist.dart';
import 'package:eventmanagement/screens/home/landingpage.dart';
import 'package:eventmanagement/screens/profile/profilepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/login.dart';
import 'authentication/signup.dart';
import 'screens/eventchatscreen/data_controller.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(DataController());

  runApp(const Maina());
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    /// Login & Signup routes
    GoRoute(path: '/login', builder: (context, state) => const Logina()),
    GoRoute(path: '/signup', builder: (context, state) => const Signupa()),

    /// Shell route for bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return LandingPage(navigationShell: navigationShell);
      },
      branches: [
        /// Home tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/eventlist',
              builder: (context, state) => const EventListScreen(),
              routes: [
                GoRoute(
                  path: 'eventdetails', // relative path 🔑
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>? ?? {};
                    return EventDetailScreen(
                      eventId: extra['eventId'],
                      eventData: extra['data'],
                      documentId: extra['documentId'],
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'eventinvite',
                      builder: (context, state) {
                        final eventId =
                            state.extra
                                as String; // <- fetch eventId from extra
                        return EventInvite(eventId: eventId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        /// Courses tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/eventcreation',
              builder: (context, state) => const EventCreationPage(),
            ),
          ],
        ),

        // / Profile tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/messagescreen',
              builder: (context, state) => MessageScreen(),
              routes: [
                // Group Chat
                GoRoute(
                  path: '/chatroomscreen/:groupId/:name',
                  builder: (context, state) {
                    final groupId = state.pathParameters['groupId']!;
                    final name = Uri.decodeComponent(
                      state.pathParameters['name']!,
                    );

                    final extra = state.extra as Map<String, dynamic>?;

                    return ChatRoomScreen(
                      groupId: groupId,
                      name: name,
                      image: extra?['image'] ?? '',
                      fcmToken: extra?['fcmToken'] ?? '',
                      uid: extra?['uid'] ?? '',
                    );
                  },
                ),

                // Direct Chat
                GoRoute(
                  path: 'directchat/:groupId/:name',
                  builder: (context, state) {
                    final groupId = state.pathParameters['groupId']!;
                    final name = Uri.decodeComponent(
                      state.pathParameters['name']!,
                    );

                    // Fetch query parameters
                    final image = state.uri.queryParameters['image'] ?? '';
                    final fcmToken =
                        state.uri.queryParameters['fcmToken'] ?? '';
                    final uid = state.uri.queryParameters['uid'] ?? '';

                    return ChatRoomScreen(
                      groupId: groupId,
                      name: name,
                      image: image,
                      fcmToken: fcmToken,
                      uid: uid,
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        /// Settings tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class Maina extends StatelessWidget {
  const Maina({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
