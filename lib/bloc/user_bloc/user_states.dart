import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserState {
  const UserState([List props = const []]) : super();
}

class UserEmpty extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> Function() user;

  UserLoaded({required this.user}) : super([user]);
}

class UserError extends UserState {
  final String? errorMsg;
  UserError({this.errorMsg});
}