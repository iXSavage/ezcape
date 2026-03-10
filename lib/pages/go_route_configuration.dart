import 'package:ezcape/bottom_navigation_bar.dart';
import 'package:ezcape/pages/auth_gate.dart';
import 'package:ezcape/pages/bio_page.dart';
import 'package:ezcape/pages/choose_interest.dart';
import 'package:ezcape/pages/creating_escapade/create_escapade.dart';
import 'package:ezcape/pages/creating_escapade/escapade.dart';
import 'package:ezcape/pages/creating_escapade/share_escapade.dart';
import 'package:ezcape/pages/exploring_escapades/escapade_details.dart';
import 'package:ezcape/pages/navigation/home.dart';
import 'package:ezcape/pages/sign_in.dart';
import 'package:ezcape/pages/sign_up.dart';
import 'package:ezcape/pages/walkthrough.dart';
import 'package:ezcape/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router =
    GoRouter(initialLocation: '/splashScreen', routes: <RouteBase>[
  GoRoute(
      path: '/home', name: 'home', builder: (context, state) => const Home()),
  GoRoute(
      path: '/signUp', name: 'signUp', builder: (context, state) => SignUp()),
  GoRoute(
      path: '/signIn', name: 'signIn', builder: (context, state) => SignIn()),
  GoRoute(
      path: '/authGate',
      name: 'authGate',
      builder: (context, state) => const AuthGate()),
  GoRoute(
      path: '/splashScreen',
      name: 'splashScreen',
      builder: (context, state) => const SplashScreen()),
  GoRoute(
      path: '/chooseInterest',
      name: 'chooseInterest',
      builder: (context, state) => const ChooseInterest()),
  GoRoute(
      path: '/createEscapade',
      name: 'createEscapade',
      builder: (context, state) => const CreateEscapade()),
  GoRoute(
      path: '/bioPage',
      name: 'bioPage',
      builder: (context, state) => const BioPage()),
  GoRoute(
      path: '/walkthrough',
      name: 'walkthrough',
      builder: (context, state) => const Walkthrough()),
  GoRoute(
      path: '/customBottomNavigationBar',
      name: 'customBottomNavigationBar',
      builder: (context, state) => CustomBottomNavigationBar()),
  GoRoute(
      path: '/shareEscapade',
      name: 'shareEscapade',
      builder: (context, state) {
        final Map<String, dynamic> escapade =
            state.extra as Map<String, dynamic>;
        return ShareEscapade(escapade: escapade);
      }),
  GoRoute(
      path: '/escapade',
      name: 'escapade',
      builder: (context, state) {
        final Map<String, dynamic> escapade =
            state.extra as Map<String, dynamic>;
        return Escapade(
          escapade: escapade,
        );
      }),
  GoRoute(
      path: '/escapadeDetails',
      name: 'escapadeDetails',
      builder: (context, state) {
        final Map<String, dynamic> escapade =
            state.extra as Map<String, dynamic>;
        return EscapadeDetails(
          escapade: escapade,
        );
      }),
]);
