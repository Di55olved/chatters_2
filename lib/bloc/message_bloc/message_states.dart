import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MsgState {
  const MsgState([List props = const []]) : super();
}

class MsgEmpty extends MsgState {}

class MsgLoading extends MsgState {}

class MsgLoaded extends MsgState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> Function() user;

  MsgLoaded({required this.user}) : super([user]);
}

class MsgError extends MsgState {
  final String? errorMsg;
  MsgError({this.errorMsg});
}
