
import 'package:chatters_2/core/network.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MockUserRepo implements UserRepository {
  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>> Function()> getuser() {
    // TODO: implement getuser
    throw UnimplementedError();
   //      return BehaviorSubject<QuerySnapshot<Map<String, dynamic>>>.fromFuture(
    //   Future.value(
    //         QueryDocumentSnapshot<Map<String, dynamic>>(
    //           data: {
    //             'id': 'id123',
    //             'about': 'about',
    //             'createdAt': 'createdAt',
    //             'isOnline': false,
    //             'lastActive': 'lastActive',
    //             'email': 'email',
    //             'pushToken': 'pushToken',
    //             'name': 'Elenios',
    //             'image': 'image',
    //           },
    //         ),
      
    //   ),
    // ).stream;

  }

  @override
  // TODO: implement userApiClient
  UserApiClient get userApiClient => throw UnimplementedError();
}
