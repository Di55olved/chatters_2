import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/bloc/user_bloc/user_bloc.dart';
import 'package:chatters_2/bloc/user_bloc/user_events.dart';
import 'package:chatters_2/bloc/user_bloc/user_states.dart';
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

    blocTest(
      'emit [UserLoading, UserLoadedMoc]',
      build: () => mocBLoc,
      act: (bloc) => bloc.add(const FetchUserMoc()),
      expect: () => [
        isA<UserLoading>(),
        isA<UserLoadedMoc>().having(
          (UserLoadedMoc m) => m.user,
          'users',
          containsAll([
            isA<Cuser>(), // Matcher for Cuser instances
            isA<Cuser>(), // Matcher for another Cuser instance
          ]),
        ),
      ],
    );
  });
}
