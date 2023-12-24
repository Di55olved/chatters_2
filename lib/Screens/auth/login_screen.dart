// //import 'package:flutter/cupertino.dart';

// import 'dart:io';
// import 'dart:developer';

// import 'package:chatters_2/API/api.dart';
// import 'package:chatters_2/Screens/home_screen.dart';
// import 'package:chatters_2/Support/dialogs.dart';
// import 'package:chatters_2/core/repository/user_repo.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class LoginScreen extends StatefulWidget {
//   final UserRepository userRepository;
//   const LoginScreen({Key? key, required this.userRepository}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _isAnimate = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         _isAnimate = true;
//       });
//     });
//   }

//   _googleHandleClicked() {
//     Dialogs.showProgressBar(context);
//     _signInWithGoogle().then((user) async {
//       Navigator.pop(context);
//       if (user != null) {
//         log("User: ${user.user}");
//         log("User Additional Info: ${user.additionalUserInfo}");

//         if (await APIs.chatterExists()) {
//           // ignore: use_build_context_synchronously
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) =>  HomeScreen(userRepository: widget.userRepository)));
//         } else {
//           APIs.createChatter().then((value) {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (_) =>  HomeScreen(userRepository: widget.userRepository)));
//           });
//         }

//         //navigate to Home screen
//       }
//     });
//   }

//   Future<UserCredential?> _signInWithGoogle() async {
//     try {
//       await InternetAddress.lookup('google.com');

//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );

//       // Once signed in, return the UserCredential
//       return await APIs.auth.signInWithCredential(credential);
//     } catch (e) {
//       log('\n_signInWithGoogle: $e');
//       Dialogs.showSnackBar(context, "$e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Welcome to Chatters"),
//         automaticallyImplyLeading: false,
//       ),
//       body: Stack(children: [
//         AnimatedPositioned(
//             duration: const Duration(seconds: 1),
//             top: MediaQuery.of(context).size.height * .15,
//             left: _isAnimate
//                 ? MediaQuery.of(context).size.width * .25
//                 : -MediaQuery.of(context).size.width * .5,
//             width: MediaQuery.of(context).size.width * .5,
//             child: Image.asset('assets/images/chat.png')),
//         Positioned(
//           bottom: MediaQuery.of(context).size.height * .15,
//           left: MediaQuery.of(context).size.width * .05,
//           width: MediaQuery.of(context).size.width * .9,
//           height: MediaQuery.of(context).size.height * .06,
//           child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                   shape: const StadiumBorder(),
//                   backgroundColor: Colors.indigo.shade200,
//                   elevation: 1),
//               onPressed: () {
//                 _googleHandleClicked();
//               },
//               label: RichText(
//                   text: const TextSpan(children: [
//                 TextSpan(text: "Login with "),
//                 TextSpan(
//                     text: "Google",
//                     style: TextStyle(fontWeight: FontWeight.bold))
//               ])),
//               icon: Image.asset(
//                 'assets/images/google.png',
//                 height: MediaQuery.of(context).size.height * .035,
//               )),
//         )
//       ]),
//     );
//   }
// }