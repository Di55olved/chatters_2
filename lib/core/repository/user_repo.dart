import 'package:chatters_2/models/user.dart';
import 'package:chatters_2/core/network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final UserApiClient userApiClient;

  UserRepository({required this.userApiClient});

  Future<Stream<QuerySnapshot<Map<String, dynamic>>> Function()>
      getuser() async {
    return userApiClient.getAllUsers;
  }

  Future<List<Cuser>> getuserMoc() async {
    return userApiClient.getAllUsersMoc();
  }
}
