


import 'package:chatters_2/bloc/user_bloc/user_events.dart';
import 'package:chatters_2/bloc/user_bloc/user_states.dart';
import 'package:chatters_2/Core/repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserLoading()) {
    on<FetchUser>((event, emit) async {
      await _getUser(emit);
    });

    // on<FetchUserMoc>((event, emit) async {
    //   await _getUserMoc(emit);
    // });

  }

  Future<void> _getUser(emit) async {
    emit(UserLoading());
    try {
      final Stream<QuerySnapshot<Map<String, dynamic>>> Function() user = await userRepository.getuser();
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(errorMsg: e.toString()));
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