//import 'package:flutter/cupertino.dart';
import 'dart:developer';
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Navigaitions/routes_names.dart';
import 'package:chatters_2/Widgets/my_assets.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final UserRepository? userRepository;
  const SplashScreen({super.key, required this.userRepository});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (APIs.auth.currentUser != null) {
        log("User: ${APIs.auth.currentUser}");
        context.goNamed(RouteNames.homeScreen);
      } else {
        context.goNamed(RouteNames.signIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: APIs.purple),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * .15,
              left: MediaQuery.of(context).size.width * .25,
              width: MediaQuery.of(context).size.width * .5,
              child: MyAssets.logo,
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * .15,
              left: MediaQuery.of(context).size.width * .05,
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .06,
              child: const Text(
                "Powered by IBA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
