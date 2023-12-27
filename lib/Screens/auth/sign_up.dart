// ignore_for_file: use_build_context_synchronously
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Navigaitions/routes_names.dart';
import 'package:chatters_2/Screens/auth/sign_in.dart';
import 'package:chatters_2/Widgets/my_assets.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:chatters_2/main.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  final UserRepository userRepository;
  const SignUpPage({super.key, required this.userRepository});

  @override
  State<SignUpPage> createState() => _SignUpPageState();

  //Function to check for email domain
  static bool verifyEmail(String emailText) {
    if (emailText.isEmpty) {
      return false; // Return false for empty string
    }

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
                        onPressed: () async {}, child: const Text("Submit")),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyAssets.logo,
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
                        onPressed: () {
                          nameValue = nameController.text;
                          imageURLValue = imageURLController.text;
                          emailValue = emailController.text;
                          passValue = passController.text;
                          confPassValue = confPassController.text;
                          if (SignUpPage.verifyEmail(emailValue)) {
                            if ((passValue == confPassValue) &&
                                (passValue != '') &&
                                (confPassValue != '')) {
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => OTPHandler(
                              // {'name': nameValue,
                              // 'imgaeURL': imageURLValue,
                              // 'email': emailValue,
                              // 'pass': passValue,
                              // 'confPass': confPassValue, userRepository: widget.userRepository},
                              //             )));
                              context.goNamed(RouteNames.otp,
                                  queryParameters: {
                                    'name': nameValue,
                                    'imageURL': imageURLValue,
                                    'email': emailValue,
                                    'pass': passValue,
                                    'confPass': confPassValue
                                  },
                                  extra: userRepository);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Passwords Don't Match or are empty"),
                                duration: Duration(seconds: 2),
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid Email"),
                              duration: Duration(seconds: 2),
                            ));
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
                                      userRepository: widget.userRepository)),
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
