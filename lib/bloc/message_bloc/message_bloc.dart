// ignore_for_file: avoid_print

import 'package:chatters_2/api/api.dart';
import 'package:chatters_2/models/messages.dart';
import 'package:chatters_2/models/user.dart';
import 'package:chatters_2/core/repository/message_repo.dart';
import 'package:chatters_2/bloc/message_bloc/message_event.dart';
import 'package:chatters_2/bloc/message_bloc/message_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//try hydrated bloc
class MsgBloc extends Bloc<MsgEvent, MsgState> {
  final MsgRepository msgRepository;

  MsgBloc({required this.msgRepository}) : super(MsgLoading()) {
    on<FetchMsg>((event, emit) async {
      await _getMessages(event.user, emit);
    });

    on<FetchMsgMoc>((event, emit) async {
      await _getMsgMoc(emit);
    });

    on<SendMessage>((event, emit) async {
      await _sendMessages(event.user, event.message, event.type, emit);
    });

    on<SendImgMessage>((event, emit) async {
      await _sendImgMessages(event.user, event.file, emit);
    });

    on<SendVoiceMessage>((event, emit) async {
      await _sendVoiceMessage(event.user, event.file, emit);
    });
  }

  Future<void> _getMessages(user, emit) async {
    //  emit(MsgLoading());
    try {
      final Stream<QuerySnapshot<Map<String, dynamic>>> messages =
          await msgRepository.getMsg(user);
      emit(MsgLoaded(messages: messages));
    } on FirebaseException catch (e) {
      emit(MsgError(errorMsg: e.message ?? 'Error fetching messages'));
    } catch (e) {
      emit(MsgError(errorMsg: 'Unknown error occurred'));
    }
  }

  Future<void> _sendMessages(user, message, type, emit) async {
    // emit(MsgLoading());
    try {
      bool check = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('my_users')
          .doc(APIs.auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) => documentSnapshot.exists);

      if (check == false) {
        final userData = await APIs.firestore
            .collection("users")
            .doc(APIs.auth.currentUser!.uid)
            .get();

        await APIs.firestore
            .collection('users')
            .doc(user.id)
            .collection("my_users")
            .doc(APIs.auth.currentUser!.uid)
            .set(userData.data()!);
        await msgRepository.sendMsg(user, message, type);
        final Stream<QuerySnapshot<Map<String, dynamic>>> messages =
            await msgRepository.getMsg(user); // Fetch updated messages
        emit(MsgLoaded(messages: messages)); // Emit the updated message list
      } else {
        await msgRepository.sendMsg(user, message, type);
        final Stream<QuerySnapshot<Map<String, dynamic>>> messages =
            await msgRepository.getMsg(user); // Fetch updated messages
        emit(MsgLoaded(messages: messages)); // Emit the updated message list
      }
    } on FirebaseException catch (e) {
      emit(MsgError(errorMsg: e.message ?? 'Error fetching messages'));
    } catch (e) {
      emit(MsgError(errorMsg: 'Unknown error occurred'));
    }
  }

  Future<void> _sendImgMessages(user, file, emit) async {
    //emit(MsgImgLoading());
    try {
      bool check = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('my_users')
          .doc(APIs.auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) => documentSnapshot.exists);
      if (check == false) {
        final userData = await APIs.firestore
            .collection("users")
            .doc(APIs.auth.currentUser!.uid)
            .get();

        await APIs.firestore
            .collection('users')
            .doc(user.id)
            .collection("my_users")
            .doc(APIs.auth.currentUser!.uid)
            .set(userData.data()!);

        await msgRepository.sendImgMsg(user, file);
        final Stream<QuerySnapshot<Map<String, dynamic>>> messages =
            await msgRepository.getMsg(user); // Fetch updated messages
        emit(MsgLoaded(messages: messages));
      } else {
        await msgRepository.sendImgMsg(user, file);
        final Stream<QuerySnapshot<Map<String, dynamic>>> messages =
            await msgRepository.getMsg(user); // Fetch updated messages
        emit(MsgLoaded(messages: messages));
      }
    } on FirebaseException catch (e) {
      emit(MsgError(errorMsg: e.message ?? 'Error fetching messages'));
    } catch (e) {
      emit(MsgError(errorMsg: 'Unknown error occurred'));
    }
  }

  Future<void> _sendVoiceMessage(user, file, emit) async {
    try {
      bool check = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('my_users')
          .doc(APIs.auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) => documentSnapshot.exists);
      if (check == false) {
        final userData = await APIs.firestore
            .collection("users")
            .doc(APIs.auth.currentUser!.uid)
            .get();

        await APIs.firestore
            .collection('users')
            .doc(user.id)
            .collection("my_users")
            .doc(APIs.auth.currentUser!.uid)
            .set(userData.data()!);

        await msgRepository.sendVoiceMsg(user, file);
        final Stream<QuerySnapshot<Map<String, dynamic>>> messages =
            await msgRepository.getMsg(user); // Fetch updated messages
        emit(MsgLoaded(messages: messages));
      } else {
        await msgRepository.sendVoiceMsg(user, file);
        final Stream<QuerySnapshot<Map<String, dynamic>>> messages =
            await msgRepository.getMsg(user); // Fetch updated messages
        emit(MsgLoaded(messages: messages));
      }
    } on FirebaseException catch (e) {
      emit(MsgError(errorMsg: e.message ?? 'Error fetching messages'));
    } catch (e) {
      emit(MsgError(errorMsg: 'Unknown error occurred'));
    }
  }

  Future<void> _getMsgMoc(Emitter<MsgState> emit) async {
    emit(MsgLoading());
    try {
      final List<Messages> message = await msgRepository.getMsgMoc();
      emit(MsgLoadedMoc(messages: message));
    } catch (e) {
      emit(MsgError(errorMsg: e.toString()));
    }
  }
}
