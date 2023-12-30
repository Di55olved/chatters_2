
// import 'package:chatters_2/Screens/home_screen.dart';
// import 'package:chatters_2/Screens/splash_screen.dart';
// import 'package:chatters_2/Screens/view_user_profile_screen.dart';
// import 'package:chatters_2/core/network.dart';
// import 'package:chatters_2/core/repository/user_repo.dart';
// import 'package:chatters_2/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//import 'package:golden_toolkit/golden_toolkit.dart';

// void main() {

//   var http;
//   setUpAll(() => {
//     loadAppFonts(),  
//     });
//   testGoldens('Golden test', (tester) async {
//     final builder = DeviceBuilder()
//       ..overrideDevicesForAllScenarios(devices: [
//         Device.phone,
//         Device.iphone11,
//         Device.tabletPortrait,
//         Device.tabletLandscape,
//       ])
//       ..addScenario(
//         widget: const ViewProfileScreen(user: null,),
//         name: 'default page',
//       );
//     await tester.pumpDeviceBuilder(builder,
//         wrapper: materialAppWrapper(
//             theme: ThemeData.light(), platform: TargetPlatform.android));

//     await screenMatchesGolden(tester, 'ui_sc.dart');
//   });
// }

// Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserMoc() {
//     // Simulating the conversion of List<Cuser> to a Stream<QuerySnapshot>
//     final Stream<QuerySnapshot<Map<String, dynamic>>> users = [
//       Cuser(id: 'id', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'John', image: 'image'),
//       Cuser(id: 'id2', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'Doe', image: 'image'),
//       Cuser(id: 'id3', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'Marry', image: 'image'),
//       Cuser(id: 'id4', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'James', image: 'image'),
//       Cuser(id: 'id5', about: 'about', createdAt: 'createdAt', isOnline: false, lastActive: 'lastActive', email: 'email', pushToken: 'pushToken', name: 'Elenios', image: 'image'),
//       // Add other Cuser instances as needed
//     ] as Stream<QuerySnapshot<Map<String, dynamic>>>;

//     return users;

//   }