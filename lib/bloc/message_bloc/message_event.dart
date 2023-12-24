
import 'package:equatable/equatable.dart';

abstract class MsgEvent extends Equatable {
  const MsgEvent([List props = const []]) : super();
}

class FetchMsg extends MsgEvent {
  const FetchMsg() : super();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchMsgMoc extends MsgEvent {
  const FetchMsgMoc() : super();

  @override
  List<Object?> get props => throw UnimplementedError();
}