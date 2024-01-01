import 'package:bloc_test/bloc_test.dart';
import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/bloc/message_bloc/message_bloc.dart';
import 'package:chatters_2/bloc/message_bloc/message_event.dart';
import 'package:chatters_2/bloc/message_bloc/message_states.dart';
import 'package:flutter_test/flutter_test.dart';

import 'msg_repo_moc.dart';

void main() {
  group('Search repo bloc', () {
    late MsgBloc mocBLoc;
    late MocMsgRepo mocRepo;

    setUpAll(() {
      mocRepo = MocMsgRepo();
      mocBLoc = MsgBloc(msgRepository: mocRepo);
    });

    blocTest(
      'emit [UserLoading, UserLoadedMoc]',
      build: () => mocBLoc,
      act: (bloc) => bloc.add(FetchMsgMoc(
          user: Cuser(
              id: 'id',
              about: 'about',
              createdAt: 'createdAt',
              isOnline: false,
              lastActive: 'lastActive',
              email: 'email',
              pushToken: 'pushToken',
              name: 'Ejaz',
              image: 'image'))),
      expect: () => [
        isA<MsgLoading>(), // Matcher for MsgLoading instance
        isA<MsgLoadedMoc>().having(
          (MsgLoadedMoc m) => m.messages,
          'messages',
          containsAll([
            isA<Messages>(), // Matcher for Messages instances
            isA<Messages>(), // Matcher for another Messages instance
          ]),
        ),
      ],
    );
  });
}
