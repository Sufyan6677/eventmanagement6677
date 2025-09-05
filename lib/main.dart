import 'package:eventmanagement/acceptrejectfinal.dart';
import 'package:eventmanagement/authentication/firebase_options.dart';

import 'package:eventmanagement/screens/eventcreation2.dart';
import 'package:eventmanagement/screens/eventdetails.dart';
import 'package:eventmanagement/screens/eventinvite.dart';
import 'package:eventmanagement/screens/home/eventlist.dart';
import 'package:eventmanagement/screens/home/landingpage.dart';
import 'package:eventmanagement/screens/profile/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/login.dart';
import 'authentication/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Maina());
}

final _router = GoRouter(
  initialLocation: '/eventlist',
  routes: [
    /// Login & Signup routes
    GoRoute(path: '/login', builder: (context, state) => const Logina()),
    GoRoute(path: '/signup', builder: (context, state) => const Signupa()),

    GoRoute(
      path: '/acceptrejectfinal',
      builder: (context, state) {
        return Acceptrejectfinal();
      },
    ),

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
              path: '/settings',
              builder: (context, state) => const ProfilePage(),
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
