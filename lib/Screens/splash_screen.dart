//import 'package:flutter/cupertino.dart';
import 'dart:developer';
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Core/repository/message_repo.dart';
import 'package:chatters_2/Screens/auth/sign_in.dart';
import 'package:chatters_2/Screens/home_screen.dart';
import 'package:chatters_2/Core/repository/user_repo.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final UserRepository userRepository;
    final MsgRepository msgRepository;

  const SplashScreen({Key? key, required this.userRepository, required this.msgRepository})
      : super(key: key);

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(userRepository: widget.userRepository, msgRepository: widget.msgRepository,),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  SignInPage(userRepository: widget.userRepository, msgRepository: widget.msgRepository,)),
        );
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
              child: Image.asset('assets/images/briefChatLogo.png'),
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
