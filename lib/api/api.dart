// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chatters_2/models/messages.dart';
import 'package:chatters_2/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class APIs extends ChangeNotifier {
  //image url
  static String hiURl =
      "https://cdn-icons-png.flaticon.com/512/6028/6028690.png";

  //some function to load NetworkImage()
  static ImageProvider buildNetworkImage(Cuser user) {
    log("user imageURL: ${user.image.toString()}");
    try {
      return NetworkImage(user.image.toString());
    } catch (e) {
      if (e is NetworkImageLoadException) {
        // Handle specific NetworkImageLoadException
        log("NetworkImageLoadException: $e");
      } else {
        // Handle other exceptions
        log("Error loading image: $e");
      }
      return NetworkImage(hiURl);
    }
  }

  //for auntheniciation
  static var auth = FirebaseAuth.instance;

  //color theme:
  static Color purple = const Color.fromARGB(255, 47, 24, 71);
  static Color yellow = const Color.fromARGB(255, 255, 201, 0);
  static Color orange = const Color.fromARGB(255, 241, 89, 70);

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  //for accessing firebase messaging (push notifications)
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  //for getting FirebaseMessaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fmessaging.requestPermission();
    fmessaging.getToken().then((value) {
      if (value != null) {
        me.pushToken = value;
        print('push token: $value');
      }
    });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  //send push notifications
  static Future<void> sendPushNotifications(Cuser cuser, String msg) async {
    try {
      final body = {
        "to": cuser.pushToken,
        "notification": {
          "title": cuser.name,
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "click_action": "User ID: ${me.id}",
        },
      };
      var response =
          await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    "key=AAAAwrJIhbw:APA91bHKQRP9Bjz5n40ri4z7T3dgM9bkQWtZ1FDlH4qOLiLigZkE44sUw_dj6YPfy0FkZ5kD7feD-DiOSsMD0MuQOsKji5RAybB1r9mupj1uLT6VR3Q491G1CJ2SEo-g3yG-TiFVTtnT"
              },
              body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print("\nsendPushNotifications: $e");
    }
  }

  static late Cuser me;
  //getter method
  //TODO: uncheck used on nul value
  static get user => auth.currentUser!;

  // checking if user already exits
  static Future<bool> chatterExists() async {
    return (await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // checking if my_user already exits

  static Future<bool> addChatterExists(String email) async {
    try {
      // Query the users collection for the given email
      final querySnapshot = await firestore
          .collection("users")
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final userId = querySnapshot.docs.first.id;

        // Check if the user is not the current user
        if (userId != auth.currentUser!.uid) {
          // Set the user data in the "my_users" subcollection
          await firestore
              .collection('users')
              .doc(auth.currentUser!.uid)
              .collection("my_users")
              .doc(userId)
              .set(userData);

          return true;
        }
      }

      return false;
    } catch (error) {
      print("Error adding chatter: $error");
      return false;
    }
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = Cuser.fromJson(user.data()!);
        //   me = Cuser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
        log('My Data:${user.data()}');

        //update Cuser properties
      } else {
        await createChatter().then((value) => getSelfInfo());
      }
    });
  }

  //new chatter
  static Future<void> createChatter(
      {String name = 'Unnamed',
      String imageURL =
          'https://static.wikia.nocookie.net/jujutsu-kaisen/images/3/3d/Toji_kills_himself_to_save_Megumi_%28Anime%29.png/revision/latest?cb=20231109213017'}) async {
    final time = DateTime.now().toString();

    final chatterUser = Cuser(
        id: user.uid,
        about: "Salam, Habibi I am a Chatter now",
        createdAt: time,
        isOnline: false,
        lastActive: time,
        email: user.email.toString(),
        pushToken: '',
        name: name,
        image: imageURL);

    return (await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatterUser.toJson()));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection("users").snapshots();
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //sending message
  static Future<void> sendMessage(Cuser cuser, String msg, MsgType type) async {
    try {
      bool check = await FirebaseFirestore.instance
          .collection('users')
          .doc(cuser.id)
          .collection('my_users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) => documentSnapshot.exists);
      if (check == false) {
        final userData = await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get();

        await firestore
            .collection('users')
            .doc(cuser.id)
            .collection("my_users")
            .doc(auth.currentUser!.uid)
            .set(userData.data()!);

        final time = DateTime.now().millisecondsSinceEpoch.toString();

        final Messages message = Messages(
            toId: cuser.id!,
            msg: msg,
            read: '',
            type: type,
            fromId: user.uid,
            sent: time);

        final ref = firestore
            .collection('chats/${getConversationID(cuser.id!)}/messages/');

        await ref.doc(time).set(message.toJson()).then((value) =>
            sendPushNotifications(cuser, type == MsgType.text ? msg : 'image'));
      } else {
        final time = DateTime.now().millisecondsSinceEpoch.toString();

        final Messages message = Messages(
            toId: cuser.id!,
            msg: msg,
            read: '',
            type: type,
            fromId: user.uid,
            sent: time);

        final ref = firestore
            .collection('chats/${getConversationID(cuser.id!)}/messages/');

        await ref.doc(time).set(message.toJson()).then((value) =>
            sendPushNotifications(cuser, type == MsgType.text ? msg : 'image'));
      }
    } catch (e) {
      print('Send Message Error: $e');
    }
  }

//get all msg for a specific conversation from firestore
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      Cuser user) {
    return firestore
        .collection('chats/${getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
      'image': me.image,
    });
  }

  static Future<void> updateMessageReadStatus(Messages message) async {
    try {
      if (message.read == null || message.read.isEmpty) {
        await firestore
            .collection('chats/${getConversationID(message.fromId)}/messages/')
            .doc(message.sent)
            .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
        print('Read status updated successfully');
      } else {
        print('Read status already exists: ${message.read}');
      }
    } catch (e) {
      print('Error updating read status: $e');
      // Handle the error as needed: log, notify the user, etc.
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      Cuser user) {
    return firestore
        .collection('chats/${getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  // send image as msg
  static Future<void> sendChatImage(Cuser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id!)}/${DateTime.now().microsecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, MsgType.image);
  }

  //upload voice recording 
  static Future<void> uploadAudio(Cuser chatUser, File file) async {
    final ext = file.path.split('.').last;
 // File audioFile = File(file);
  final ref = storage.ref().child('audio/${getConversationID(chatUser.id!)}/${DateTime.now().microsecondsSinceEpoch}.$ext');

  await ref.putFile(file, SettableMetadata(contentType: 'audio/$ext'))
  .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

  String audioURL = await ref.getDownloadURL();
    await sendMessage(chatUser, audioURL, MsgType.audio);
  
}


  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      Cuser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      ' is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
      //    'push_token': me.pushToken,
    });
  }

  //update message
  static Future<void> updateMessage(Messages message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  //delete message
  static Future<void> deleteMessage(Messages message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == MsgType.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //delete chatter
  static Future<void> deleteChatTile(String? uid) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('my_users')
        .doc(uid)
        .delete();
  }
}
  //firestore.collection("users").where('id',isNotEqualTo: user.uid).snapshots()