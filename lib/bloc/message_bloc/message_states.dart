import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MsgState extends Equatable {
  const MsgState();

  @override
  List<Object?> get props => [];
}

class MsgEmpty extends MsgState {}

class MsgLoading extends MsgState {}

class MsgImgLoading extends MsgState{}

class MsgLoaded extends MsgState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> messages;

  MsgLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class SendingMsg extends MsgState {
  @override
  List<Object> get props => [];
}

class MsgSent extends MsgState {
  @override
  List<Object> get props => [];
}

class MsgError extends MsgState {
  final String? errorMsg;

  MsgError({this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
