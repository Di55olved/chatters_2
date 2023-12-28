// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Core/repository/message_repo.dart';
import 'package:chatters_2/Screens/auth/sign_in.dart';
import 'package:chatters_2/Core/repository/user_repo.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final UserRepository userRepository;
  final MsgRepository msgRepository;
  const SignUpPage({super.key, required this.userRepository, required this.msgRepository});

  @override
  State<SignUpPage> createState() => _SignUpPageState();

  //Function to check for email domain
  static bool verifyEmail(String emailText) {
    String valv = "khi.iba.edu.pk";
    String valv2 = "iba.edu.pk";

    List<String> parts = emailText.split('@');

    if (parts.length >= 2) {
      if (parts[1] == valv || parts[1] == valv2) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}

class _SignUpPageState extends State<SignUpPage> {
  //Name Controller and Value
  TextEditingController nameController = TextEditingController();
  String nameValue = '';
  //ImageURL Controller and Value
  TextEditingController imageURLController = TextEditingController();
  String imageURLValue = '';
  //Email Controller and Value
  TextEditingController emailController = TextEditingController();
  String emailValue = '';
  //Password Controller and Value
  TextEditingController passController = TextEditingController();
  String passValue = '';
  //Confirm Password Controller and Value
  TextEditingController confPassController = TextEditingController();
  String confPassValue = '';
  //OTP controller and Value
  TextEditingController otpController = TextEditingController();
  String otpValue = '';

  //Email OTP
  EmailOTP myOTP = EmailOTP();

  //Function to store the OTP
  void showPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter OTP: "),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                          label: const Text("Enter OTP (check spam folder): "),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: APIs.orange)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: APIs.orange))),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          otpValue = otpController.text;
                          bool check = await myOTP.verifyOTP(otp: otpValue);

                          if (check == true) {
                            await APIs.auth.createUserWithEmailAndPassword(
                                email: emailValue, password: passValue);
                            await APIs.createChatter(
                                name: nameValue, imageURL: imageURLValue);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignInPage(
                                        userRepository:
                                            widget.userRepository, msgRepository: widget.msgRepository,)));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid OTP, Try again"),
                              duration: Duration(seconds: 1),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: APIs.purple),
        child: ListView(
          children: [
            //iRent Logo
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage('assets/images/briefChatLogo.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Heading: Sign Up
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        color: APIs.orange,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Space
                    const SizedBox(
                      height: 40.0,
                    ),
                    //ImageURL Text Field
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: APIs.orange)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: APIs.orange)),
                      ),
                    ),
                    //Space
                    const SizedBox(height: 20.0),
                    //ImageURL Text Field
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: imageURLController,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: InputDecoration(
                        labelText: "Display Picture URL",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: APIs.orange)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: APIs.orange)),
                      ),
                    ),
                    //Space
                    const SizedBox(height: 20.0),
                    //Email Text Field
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value != null && value.length > 50) {
                          return 'Max length of 50 characters';
                        }
                        if (SignUpPage.verifyEmail(emailController.text) !=
                            true) {
                          return 'Email not from IBA';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: APIs.orange)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: APIs.orange)),
                      ),
                    ),
                    //Space
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        //Password and Confirm Password Text Fields
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            controller: passController,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              if (value != null && value.length > 20) {
                                return "Max Character limit 20";
                              }
                              if (value != null && value.length < 8) {
                                return "Password should be atleast 8 characters long";
                              }
                              // Check if the password contains at least one digit
                              if (!value!.contains(RegExp(r'\d'))) {
                                return "Password should contain at least one digit";
                              }
                              // Check if the password contains at least one uppercase character
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return "Password should contain at least one uppercase character";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                label: const Text("Password"),
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    borderSide: BorderSide(color: APIs.orange)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: APIs.orange))),
                          ),
                        ),
                        //space
                        const SizedBox(width: 25.0),
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            controller: confPassController,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              if (value != null && value.length > 20) {
                                return "Max Character limit 20";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                label: const Text("Confirm Password"),
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    borderSide: BorderSide(color: APIs.orange)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: APIs.orange))),
                          ),
                        )
                      ],
                    ),
                    //Space
                    const SizedBox(
                      height: 15.0,
                    ),
                    //Elevated Button: Sign Up
                    SizedBox(
                      width: 400.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            nameValue = nameController.text;
                            imageURLValue = imageURLController.text;
                            emailValue = emailController.text;
                            passValue = passController.text;
                            confPassValue = confPassController.text;

                            if (SignUpPage.verifyEmail(emailValue)) {
                              if (passValue == confPassValue) {
                                myOTP.setConfig(
                                    appEmail: "bh3082336888@gmail.com",
                                    appName: "iRENT",
                                    userEmail: emailValue,
                                    otpLength: 4,
                                    otpType: OTPType.digitsOnly);
                                if (await myOTP.sendOTP() == true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Otp Sent"),
                                    duration: Duration(seconds: 2),
                                  ));
                                  showPopup(context);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Oops, OTP failed to send, retry"),
                                    duration: Duration(seconds: 1),
                                  ));
                                }
                              } else {
                                log("passwords don't match");
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Passwords don't match"),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            } else {
                              log("Email not from IBA");
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Email not from IBA"),
                                duration: Duration(seconds: 2),
                              ));
                            }
                          } catch (e) {
                            log('$e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('An unexpected error occurred: $e'),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(APIs.orange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(40.0)))),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    //Space
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        //Text Line: "Have an account? Log In"
                        const Text(
                          "Have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 3.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage(
                                      userRepository: widget.userRepository, msgRepository: widget.msgRepository,)),
                            );
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(color: APIs.orange),
                          ),
                        )
                      ],
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
