import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class UserApiClient {
  final http.Client httpClient;
  static var auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late Cuser me;
  //getter method
  static get user => auth.currentUser!;
  UserApiClient({required this.httpClient});

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("my_users")
        .snapshots();
  }
 static Future<void> copyUserDataToMyUsers(String uid) async {
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid);
    DocumentSnapshot userSnapshot = await userDocRef.get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;
    CollectionReference myUsersCollectionRef =
        userDocRef.collection("my_users");
    await myUsersCollectionRef.add(userData);
  }

  

  // Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserMoc() {
  //   // Simulating the conversion of List<Cuser> to a Stream<QuerySnapshot>
  //   final List<Cuser> users = [
  //     Cuser(id: 'id', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'John', image: 'image'),
  //     Cuser(id: 'id', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'Doe', image: 'image'),
  //     Cuser(id: 'id', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'Marry', image: 'image'),
  //     Cuser(id: 'id', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'James', image: 'image'),
  //     Cuser(id: 'id', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'Elenios', image: 'image'),
  //     // Add other Cuser instances as needed
  //   ];

  //   // Convert the list of Cuser objects to QuerySnapshot objects
  //   final snapshots = users.map((user) {
  //     final data = {
  //       'id': user.id,
  //       'name': user.name,
  //       // Include other user attributes here...
  //     };
  //     return QueryDocumentSnapshot<Map<String, dynamic>>(
  //       data: data,
  //       reference: null, // Set the reference as needed
  //     );
  //   }).toList();

  //   return Stream.fromIterable([QuerySnapshot<Map<String, dynamic>>.from(
  //     snapshots,
  //     QuerySnapshotMetadata(hasPendingWrites: false), // Add metadata as needed
  //   )]);
  // }
}
