import 'package:chatters_2/core/network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MsgRepository {
  final UserApiClient userApiClient;

  MsgRepository({required this.userApiClient});

  Future<Stream<QuerySnapshot<Map<String, dynamic>>> Function()> getuser() async {
    return userApiClient.getAllUsers;
  }
  // Future<Future<List<Cuser>>> getUserMoc() async {
  //   return userApiClient.fetchUserMoc();
  // }

}