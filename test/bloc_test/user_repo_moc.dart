
import 'package:chatters_2/core/network.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockUserRepo implements UserRepository {
  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserMoc() {
    // TODO: implement getUserMoc
    throw UnimplementedError();
  }

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>> Function()> getuser() {
    // TODO: implement getuser
    throw UnimplementedError();
  }

  @override
  // TODO: implement userApiClient
  UserApiClient get userApiClient => throw UnimplementedError();
  

}
