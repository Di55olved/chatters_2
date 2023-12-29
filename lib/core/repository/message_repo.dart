import 'dart:io';

import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/core/message_api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MsgRepository {
  final MessageApiClient messageApiClient;

  MsgRepository({required this.messageApiClient});

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getMsg(Cuser user) async {
    return messageApiClient.getAllMessages(user);
  }

  Future<void> sendMsg(Cuser user, String msg, MsgType type) async {
    return messageApiClient.sendMessage(user, msg, type);
  }

  Future<void> sendImgMsg(Cuser chatUser, File file) async {
    return messageApiClient.sendChatImage(chatUser, file);
  }
}
