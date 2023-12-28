import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class UserEmpty extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> Function() user;

  UserLoaded({required this.user}) : super([user]);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String? errorMsg;
  
  UserError({this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
