import 'dart:io';

import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/core/message_api_client.dart';
import 'package:chatters_2/core/repository/message_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MocMsgRepo implements MsgRepository {
  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getMsg(Cuser user) {
    // TODO: implement getMsg
    throw UnimplementedError();
  }

  @override
  Future<List<Messages>> getMsgMoc() {
    return Future.value([
      Messages(toId: 'XYZ', msg: 'Hello', read: 'read', type: MsgType.text, fromId: 'fromId', sent: 'sent'),
      Messages(toId: 'ABC', msg: 'Hi', read: 'read', type: MsgType.image, fromId: 'fromId', sent: 'sent')
    ]);
  }

  @override
  // TODO: implement messageApiClient
  MessageApiClient get messageApiClient => throw UnimplementedError();

  @override
  Future<void> sendImgMsg(Cuser chatUser, File file) {
    // TODO: implement sendImgMsg
    throw UnimplementedError();
  }

  @override
  Future<void> sendMsg(Cuser user, String msg, MsgType type) {
    // TODO: implement sendMsg
    throw UnimplementedError();
  }

  @override
  Future<void> sendVoiceMsg(Cuser chatUser, String file) {
    // TODO: implement sendVoiceMsg
    throw UnimplementedError();
  }
  
}