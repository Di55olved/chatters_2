
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class FetchUser extends UserEvent {
  const FetchUser() : super();
}


// class FetchUserMoc extends UserEvent {
//   const FetchUserMoc() : super();

//   @override
//   List<Object?> get props => throw UnimplementedError();
// }