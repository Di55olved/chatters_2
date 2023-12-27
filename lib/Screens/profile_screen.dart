// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Screens/auth/sign_in.dart';
import 'package:chatters_2/Widgets/my_assets.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import '../Support/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  final UserRepository userRepository;
  final Cuser user;
  const ProfileScreen(
      {super.key, required this.user, required this.userRepository});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: APIs.orange,
          ),
          backgroundColor: APIs.purple,
          title: Text(
            "Profile Screen",
            style: TextStyle(color: APIs.yellow),
          ),
          // leading: const Icon(
          //   CupertinoIcons.home,
          // ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            backgroundColor: APIs.orange,
            onPressed: () async {
              Dialogs.showProgressBar(context);

              await APIs.updateActiveStatus(false);

              await APIs.auth.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SignInPage(userRepository: widget.userRepository)));
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).height * .05),
            child: ListView(
              children: [
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.03),
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.2, // Adjust as needed
                  height: MediaQuery.of(context).size.width *
                      0.2, // Adjust as needed

                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Stack(children: [
                      _image != null
                          ?
                          //local image

                          ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.sizeOf(context).height * .1),
                              child: Image.file(File(_image!),
                                  width: MediaQuery.sizeOf(context).height * .2,
                                  height:
                                      MediaQuery.sizeOf(context).height * .2,
                                  fit: BoxFit.cover))
                          :

                          //user profile picture
                          ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.sizeOf(context).height * .1),
                              child: CachedNetworkImage(
                                width: MediaQuery.sizeOf(context).height * .2,
                                height: MediaQuery.sizeOf(context).height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image!,
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                        child: Icon(
                                  CupertinoIcons.person,
                                  color: APIs.orange,
                                )),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: APIs.orange,
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.03),
                Text(widget.user.email!,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 16)),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.03),
                TextFormField(
                  onSaved: (val) => APIs.me.name = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required Field',
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: APIs.orange),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Happy Singh',
                      label: const Text('Name')),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.03),
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (val) => APIs.me.about = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: APIs.orange),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg.Academic',
                      label: const Text('About')),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.03),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(MediaQuery.sizeOf(context).width * .5,
                          MediaQuery.sizeOf(context).height * 0.06),
                      backgroundColor: APIs.orange),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      APIs.updateUserInfo().then((value) {
                        Dialogs.showSnackBar(
                            context, 'Profile Updated Successfully!');
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 28,
                  ),
                  label: const Text(
                    'Update',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height * .03,
                bottom: MediaQuery.sizeOf(context).height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: MediaQuery.sizeOf(context).height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.sizeOf(context).width * .3,
                              MediaQuery.sizeOf(context).height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          //                   log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: MyAssets.addImage),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.sizeOf(context).width * .3,
                              MediaQuery.sizeOf(context).height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          //               log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: MyAssets.camera),
                ],
              )
            ],
          );
        });
  }
}
