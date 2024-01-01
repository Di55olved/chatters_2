// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, use_build_context_synchronously
import "dart:async";

import "package:chatters_2/navigaitions/routes_names.dart";
import "package:chatters_2/core/repository/message_repo.dart";
import "package:chatters_2/core/repository/user_repo.dart";
import "package:email_otp/email_otp.dart";
import "package:flutter/material.dart";

import "package:chatters_2/api/api.dart";
import "package:chatters_2/widgets/my_assets.dart";
import "package:go_router/go_router.dart";

class OTPHandler extends StatefulWidget {
  final UserRepository userRepository;
  final MsgRepository msgRepository;
  final String name;
  final String imageURL;
  final String email;
  final String pass;
  final String confPass;

  EmailOTP myOTP = EmailOTP();

  OTPHandler(
      {super.key,
      required this.userRepository,
      required this.name,
      required this.imageURL,
      required this.email,
      required this.pass,
      required this.confPass,
      required this.msgRepository});

  @override
  State<OTPHandler> createState() => _OTPHandlerState();
}

class _OTPHandlerState extends State<OTPHandler> {
  //OTP controller and Value
  TextEditingController otpController = TextEditingController();
  String otpValue = '';

  @override
  void initState() {
    widget.myOTP.setConfig(
        appEmail: "bh3082336888@gmail.com",
        appName: "BrieF Chat",
        userEmail: widget.email,
        otpLength: 4,
        otpType: OTPType.digitsOnly);
    otpSending();
    super.initState();
  }

  Future<void> otpSending() async {
    print("Sending OTP...");
    bool check = await widget.myOTP.sendOTP();
    print("OTP sent: $check");
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Otp Sent"),
        duration: Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops, OTP failed to send, retry"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: APIs.purple,
          title:
              Center(child: Text("OTP", style: TextStyle(color: APIs.yellow))),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: MyAssets.transLogo,
              ),
            ),
            ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              BorderSide(color: APIs.orange, width: 2.0))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        otpValue = otpController.text;
                        bool check =
                            await widget.myOTP.verifyOTP(otp: otpValue);

                        if (check == true) {
                          await APIs.auth.createUserWithEmailAndPassword(
                              email: widget.email, password: widget.pass);
                          await APIs.createChatter(
                              name: widget.name, imageURL: widget.imageURL);
                          context.goNamed(RouteNames.homeScreen,
                              extra: widget.userRepository);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Invalid OTP, Try again"),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(APIs.orange),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)))),
                      child: const Text(
                        "Sumbit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        otpSending();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(APIs.orange),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)))),
                      child: const Text(
                        "Resend",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }
}
