import 'dart:developer';
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Core/repository/message_repo.dart';
import 'package:chatters_2/Screens/auth/sign_up.dart';
import 'package:chatters_2/Screens/home_screen.dart';
import 'package:chatters_2/Core/repository/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color purple = const Color.fromARGB(255, 47, 24, 71);
Color yellow = const Color.fromARGB(255, 255, 201, 0);
Color orange = const Color.fromARGB(255, 241, 89, 70);

class SignInPage extends StatefulWidget {
  final UserRepository userRepository;
  final MsgRepository msgRepository;
  const SignInPage({Key? key, required this.userRepository, required this.msgRepository}) : super(key: key);
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //Email Controller and Value
  TextEditingController emailController = TextEditingController();
  String emailValue = '';
  //Password Controller and Value
  TextEditingController passController = TextEditingController();
  String passValue = '';
  @override
  Widget build(BuildContext context) {
    return Consumer<APIs>(
      builder: (context, obj, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(color: purple),
          child: ListView(
            children: <Widget>[
              //iRent Logo image
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage("assets/images/briefChatLogo.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  //Heading: Log In
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Log In",
                      style: TextStyle(
                        color: orange,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Space
                    const SizedBox(
                      height: 40.0,
                    ),
                    //Email Text Field
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value != null && value.length > 50) {
                          return 'Max length of 50 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: orange)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: orange)),
                      ),
                    ),
                    //Space
                    const SizedBox(
                      height: 20.0,
                    ),
                    //Password Text Field
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: passController,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value != null && value.length > 20) {
                          return 'Max length of 20 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: orange)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: orange)),
                      ),
                    ),
                    //Space
                    const SizedBox(
                      height: 15.0,
                    ),
                    //Sign In Button
                    SizedBox(
                      width: 400.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          //Save credentials to Text Values
                          emailValue = emailController.text;
                          passValue = passController.text;
                          //Use FirebaseAuth.instance to sign in
                          try {
                            await APIs.auth.signInWithEmailAndPassword(
                                email: emailValue, password: passValue);
                            //Navigate to HomeScreen if Sign In was successful
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                    userRepository: widget.userRepository, msgRepository: widget.msgRepository,),
                              ),
                            );
                            //Display the exceptions
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.code == 'user-not-found'
                                      ? 'No user found for that email.'
                                      : e.code == 'wrong-password'
                                          ? 'Wrong password provided for that user.'
                                          : 'An error occurred: $e',
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('An unexpected error occurred: $e'),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(orange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(40.0)))),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    //Space
                    const SizedBox(
                      height: 15.0,
                    ),
                    //Text Line: "Don't have an account? Sign Up"
                    Row(
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 3.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => SignUpPage(
                                          userRepository: widget.userRepository, msgRepository: widget.msgRepository,
                                        )));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: orange),
                          ),
                        )
                      ],
                    ),
                    //Space
                    const SizedBox(
                      height: 15.0,
                    ),
                    //Text Line: "Forgot Password?"
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierColor: const Color.fromARGB(200, 0, 0, 0),
                            builder: (BuildContext context) {
                              TextEditingController forPass =
                                  TextEditingController();
                              return AlertDialog(
                                title: Text(
                                  "Password Reset",
                                  style: TextStyle(color: orange),
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: forPass,
                                          decoration: InputDecoration(
                                              label:
                                                  const Text("Enter Email: "),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  borderSide: BorderSide(
                                                      color: orange)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  borderSide: BorderSide(
                                                      color: orange))),
                                        ),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        orange),
                                                shape:
                                                    MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)))),
                                            onPressed: () async {
                                              String forPassValue =
                                                  forPass.text;
                                              try {
                                                if (SignUpPage.verifyEmail(
                                                    forPassValue)) {
                                                  await APIs.auth
                                                      .sendPasswordResetEmail(
                                                    email: forPassValue,
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Password Reset Email Sent"),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ));
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SignInPage(
                                                                        userRepository:
                                                                            widget.userRepository, msgRepository: widget.msgRepository,
                                                                      )));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Not an IBA Email"),
                                                    duration:
                                                        Duration(seconds: 1),
                                                  ));
                                                }
                                              } on FirebaseAuthException catch (e) {
                                                log('$e');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text("$e"),
                                                  duration: const Duration(
                                                      seconds: 1),
                                                ));
                                              }
                                            },
                                            child: const Text("Submit")),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
