import 'dart:io';

import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class APIs extends ChangeNotifier {
  //for auntheniciation
  static var auth = FirebaseAuth.instance;

  //color theme:
  static Color purple = const Color.fromARGB(255, 47, 24, 71);
  static Color yellow = const Color.fromARGB(255, 255, 201, 0);
  static Color orange = const Color.fromARGB(255, 241, 89, 70);

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

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

  static Future<void> getSelfInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = Cuser.fromJson(user.data()!);
        //   me = Cuser.fromJson(user.data()!);
        print('My Data:${user.data()}');
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
  static Future<void> sendMessage(Cuser cuser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Messages message = Messages(
        toId: cuser.id!,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref =
        firestore.collection('chats/${getConversationID(cuser.id!)}/messages/');

    await ref.doc(time).set(message.toJson());
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
        .update({'image ': me.image});
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
    await sendMessage(chatUser, imageUrl, Type.image);
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
}
  //firestore.collection("users").where('id',isNotEqualTo: user.uid).snapshots()