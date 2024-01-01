import 'dart:async';
import 'dart:developer';

import 'package:chatters_2/api/api.dart';
import 'package:chatters_2/navigaitions/routes_names.dart';
import 'package:chatters_2/widgets/my_assets.dart';
import 'package:chatters_2/core/repository/message_repo.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final UserRepository? userRepository;
  final MsgRepository msgRepository;

  const SplashScreen({
    super.key,
    required this.userRepository,
    required this.msgRepository,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    // Start the animation
    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (APIs.auth.currentUser != null) {
        log("User: ${APIs.auth.currentUser}");
        context.goNamed(RouteNames.homeScreen);
      } else {
        context.goNamed(RouteNames.signIn);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [APIs.purple, Colors.pink, APIs.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: MyAssets.transLogo,
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Text(
                "Powered by IBA",
                style: TextStyle(
                  color: APIs.yellow,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
