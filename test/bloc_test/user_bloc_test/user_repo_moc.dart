import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/core/network.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Create a mock class for UserRepository

class MockUserRepo implements UserRepository  {
  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>> Function()> getuser() {
    // TODO: implement getuser
    throw UnimplementedError();
  }

  @override
  Future<List<Cuser>> getuserMoc() {
    return Future.value([
      Cuser(
          id: 'id',
          about: 'about',
          createdAt: 'createdAt',
          isOnline: false,
          lastActive: 'lastActive',
          email: 'email',
          pushToken: 'pushToken',
          name: 'Faris',
          image: 'image'),
      Cuser(
          id: 'id',
          about: 'about',
          createdAt: 'createdAt',
          isOnline: false,
          lastActive: 'lastActive',
          email: 'email',
          pushToken: 'pushToken',
          name: 'Ejaz',
          image: 'image'),
    ]);
  }

  @override
  // TODO: implement userApiClient
  UserApiClient get userApiClient => throw UnimplementedError();
}
