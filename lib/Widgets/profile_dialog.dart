import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Screens/view_user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final Cuser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
          width: MediaQuery.sizeOf(context).width * .6,
          height: MediaQuery.sizeOf(context).height * .35,
          child: Stack(
            children: [
              //user profile picture
              Positioned(
                top: MediaQuery.sizeOf(context).height * .075,
                left: MediaQuery.sizeOf(context).width * .1,
                child:                   ClipRRect(
                    borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height * .1),
                    child: CachedNetworkImage(
                      width: MediaQuery.sizeOf(context).height * .2,
                      height: MediaQuery.sizeOf(context).height * .2,
                      fit: BoxFit.cover,
                      imageUrl: user.image!,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

              ),

              //user name
              Positioned(
                left: MediaQuery.sizeOf(context).width * .04,
                top: MediaQuery.sizeOf(context).height * .02,
                width: MediaQuery.sizeOf(context).width * .55,
                child: Text(user.name!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),

              //info button
              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () {
                      //for hiding image dialog
                      Navigator.pop(context);

                      //move to view profile screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewProfileScreen(user: user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.info_outline,
                        color: Colors.blue, size: 30),
                  ))
            ],
          )),
    );
  }
}