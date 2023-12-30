import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/bloc/user_bloc/user_bloc.dart';
import 'package:chatters_2/bloc/user_bloc/user_events.dart';
import 'package:chatters_2/bloc/user_bloc/user_states.dart';
import 'package:chatters_2/core/network.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'user_repo_moc.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('Search repo bloc', () {
    late UserBloc mocBLoc;
    late MockUserRepo mocRepo;

    setUpAll(() {
      mocRepo = MockUserRepo();
      mocBLoc = UserBloc(userRepository: mocRepo);
    });

    blocTest('emit [UserLoading, UserLoaded]',
        build: () => mocBLoc,
        act: (bloc) => bloc.add(const FetchUser()),
        expect: (() => [
              UserLoading(),
              UserLoaded(
                user: [
                  Cuser(
                      id: 'id123',
                      about: 'about',
                      createdAt: 'createdAt',
                      isOnline: false,
                      lastActive: 'lastActive',
                      email: 'email',
                      pushToken: 'pushToken',
                      name: 'Elenios',
                      image: 'image')
                ] as Stream<QuerySnapshot<Map<String, dynamic>>> Function(),
              )
            ]));
  });
}

