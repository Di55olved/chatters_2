import 'dart:io';

import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:equatable/equatable.dart';

abstract class MsgEvent extends Equatable {
  const MsgEvent();

//  const MsgEvent({this.user, List<Object?> props = const []}) : super();

  @override
  List<Object?> get props => []; // Include user in props
}

class FetchMsg extends MsgEvent {
  final Cuser user;

  const FetchMsg({required this.user});

  @override
  List<Object?> get props => [user];
}

class SendMessage extends MsgEvent {
  final Cuser user;
  final String message;
  final MsgType type;

  SendMessage(this.user, this.message, this.type);

  @override
  List<Object?> get props => [user,message];
}

class SendImgMessage extends MsgEvent {
  final Cuser user;
  final File file;

  SendImgMessage(this.user, this.file);

  @override
  List<Object?> get props => [user,file];
}
