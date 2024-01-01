// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';
import 'package:chatters_2/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:chatters_2/models/user.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    super.key,
    required this.user,
  });

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User profile picture
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: InkWell(
                onLongPress: () async {
                  try {
                    // Fetch image URL from Firestore
                    String? imageUrl = user.image;

                    // Use a network library (e.g., http) to download the image data
                    final response = await http.get(Uri.parse(imageUrl!));

                    if (response.statusCode == 200) {
                      // Convert the response body to Uint8List
                      Uint8List uint8List = response.bodyBytes;

                      // Save the image to the gallery
                      await ImageGallerySaver.saveImage(
                        uint8List,
                        isReturnImagePathOfIOS:
                            true, // Set to true if targeting iOS
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Image Saved Successsfully"),
                        duration: Duration(seconds: 2),
                      ));

                      Navigator.pop(context);
                    } else {
                      print('Failed to download image: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error While Saving Image: $e');
                  }
                },
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: APIs.buildNetworkImage(user),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                ),
              ),
            ),

            // User name
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: Text(
                user.name!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
