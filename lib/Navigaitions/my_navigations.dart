import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Navigaitions/routes_names.dart';
import 'package:chatters_2/Screens/auth/otp.dart';
import 'package:chatters_2/Screens/auth/sign_in.dart';
import 'package:chatters_2/Screens/auth/sign_up.dart';
import 'package:chatters_2/Screens/chatter_screen.dart';
import 'package:chatters_2/Screens/home_screen.dart';
import 'package:chatters_2/Screens/profile_screen.dart';
import 'package:chatters_2/Screens/splash_screen.dart';
import 'package:chatters_2/Screens/view_user_profile_screen.dart';
import 'package:chatters_2/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyRouter {
  final GoRouter router;

  MyRouter()
      : router = GoRouter(
          initialLocation: '/',
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: <RouteBase>[
            GoRoute(
              name: RouteNames.splashScreen,
              path: '/',
              builder: (BuildContext context, GoRouterState state) {
                return SplashScreen(userRepository: userRepository, msgRepository: msgRepository);
              },
            ),
            GoRoute(
              name: RouteNames.signIn,
              path: '/sign-in',
              builder: (BuildContext context, GoRouterState state) {
                return SignInPage(userRepository: userRepository, msgRepository: msgRepository);
              },
            ),
            GoRoute(
              name: RouteNames.homeScreen,
              path: '/home',
              builder: (BuildContext context, GoRouterState state) {
                return HomeScreen(userRepository: userRepository, msgRepository: msgRepository);
              },
            ),
            GoRoute(
              name: RouteNames.signUp,
              path: '/sign-up',
              builder: (BuildContext context, GoRouterState state) {
                return SignUpPage(userRepository: userRepository, msgRepository: msgRepository);
              },
            ),
            GoRoute(
              name: RouteNames.otp,
              path: '/otp',
              builder: (BuildContext context, GoRouterState state) {
                // Extract query parameters
                final Map<String, dynamic> queryParams =
                    state.uri.queryParameters;
                // Access individual parameters
                final String nameValue = queryParams['name'] as String;
                final String imageURLValue = queryParams['imageURL'] as String;
                final String emailValue = queryParams['email'] as String;
                final String passValue = queryParams['pass'] as String;
                final String confPassValue = queryParams['confPass'] as String;

                // Now, you can navigate to your OTP screen and pass the extracted data
                return OTPHandler(
                  name: nameValue,
                  imageURL: imageURLValue,
                  email: emailValue,
                  pass: passValue,
                  confPass: confPassValue,
                  userRepository: userRepository,
                  msgRepository: msgRepository,
                );
              },
            ),
            GoRoute(
              name: RouteNames.chatterScreen,
              path: '/chatter-screen',
              builder: (BuildContext context, GoRouterState state) {
                final Cuser user = state.extra as Cuser;
                return ChatterScreen(user: user, msgRepository: msgRepository,);
              },
            ),
            GoRoute(
              name: RouteNames.profileScreen,
              path: '/profile-screen',
              builder: (BuildContext context, GoRouterState state) {
                final Cuser user = state.extra as Cuser;
                return ProfileScreen(
                    userRepository: userRepository, user: user, msgRepository: msgRepository);
              },
            ),
            GoRoute(
              name: RouteNames.viewUserProfileScreen,
              path: '/view-user-profile-screen',
              builder: (BuildContext context, GoRouterState state) {
                final Cuser user = state.extra as Cuser;
                return ViewProfileScreen(
                  user: user,
                );
              },
            ),
          ],
        );
}
