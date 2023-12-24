
import 'package:chatters_2/bloc/message_bloc/message_event.dart';
import 'package:chatters_2/bloc/message_bloc/message_states.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MsgBloc extends Bloc<MsgEvent, MsgState> {
  final UserRepository userRepository;

  MsgBloc({required this.userRepository}) : super(MsgLoading()) {
    on<FetchMsg>((event, emit) async {
      await _getMsg(emit);
    });

    // on<FetchUserMoc>((event, emit) async {
    //   await _getUserMoc(emit);
    // });

  }

  Future<void> _getMsg(Emitter<MsgState> emit) async {
    emit(MsgLoading());
    try {
      final Stream<QuerySnapshot<Map<String, dynamic>>> Function() user = await userRepository.getuser();
      emit(MsgLoaded(user: user));
    } catch (e) {
      emit(MsgError(errorMsg: e.toString()));
    }
  }


  // Future<void> _getUserMoc(Emitter<UserState> emit) async {
  //   emit(UserLoading());
  //   try {
  //     final Future<List<Cuser>> user = await userRepository.getUserMoc();
  //     emit(UserLoaded(user: user));
  //   } catch (e) {
  //     emit(UserError(errorMsg: e.toString()));
  //   }
  // }
}