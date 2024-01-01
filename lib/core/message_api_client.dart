import 'dart:io';

import 'package:chatters_2/api/api.dart';
import 'package:chatters_2/models/messages.dart';
import 'package:chatters_2/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class MessageApiClient {
  late final http.Client httpClient;
  static var auth = FirebaseAuth.instance;
  static get user => auth.currentUser!;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  MessageApiClient({required this.httpClient});
  static FirebaseStorage storage = FirebaseStorage.instance;
  

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(Cuser user) {
    return firestore
        .collection('chats/${APIs.getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(Cuser cuser, String msg, MsgType type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Messages message = Messages(
        toId: cuser.id!,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${APIs.getConversationID(cuser.id!)}/messages/');

    await ref.doc(time).set(message.toJson()).then((value) =>
        APIs.sendPushNotifications(
            cuser, message.type == MsgType.text ? msg : 'image'));
  }

  Future<void> sendChatImage(Cuser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${APIs.getConversationID(chatUser.id!)}/${DateTime.now().microsecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    }).then((value) => APIs.sendPushNotifications(chatUser, 'image'));

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, MsgType.image);
  }

  //upload voice recording 
  Future<void> uploadAudio(Cuser chatUser, String file) async {
    final ext = file.split('.').last;
  File audioFile = File(file);
  final ref = storage.ref().child('audio/${APIs.getConversationID(chatUser.id!)}/${DateTime.now().microsecondsSinceEpoch}.$ext');

  await ref.putFile(audioFile, SettableMetadata(contentType: 'audio/$ext'))
  .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

  String audioURL = await ref.getDownloadURL();
    await sendMessage(chatUser, audioURL, MsgType.audio);
  
}

  Future<List<Messages>> getAllMsgMoc() async{ 
    return [
      Messages(toId: 'XYZ', msg: 'Hello', read: 'read', type: MsgType.text, fromId: 'fromId', sent: 'sent'),
      Messages(toId: 'ABC', msg: 'Hi', read: 'read', type: MsgType.image, fromId: 'fromId', sent: 'sent')

    ];
  }
}

   // // Method for sending images using the existing sendChatImage API
  // Future<void> sendImageMessage(Cuser cuser, File file) async {
  //   // You can call the existing APIs.sendChatImage method here
  //   await APIs.sendChatImage(cuser, file);
  // }
  